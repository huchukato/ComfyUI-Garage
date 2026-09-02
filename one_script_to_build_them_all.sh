#!/bin/bash

# Un Anello per dominarli tutti, un Anello per trovarli,
# un Anello per ghermirli e nell'oscurità incatenarli.

# Build base image + ALL worker images in one shot.
# Usage:
#   ./one_script_to_build_them_all.sh              # build base + all workers
#   ./one_script_to_build_them_all.sh --base-only  # build only the base images
#   ./one_script_to_build_them_all.sh cu13-mmh3 cu128-wan22   # build specific workers
#   ./one_script_to_build_them_all.sh --no-cache    # force rebuild all
#   ./one_script_to_build_them_all.sh --skip-base   # skip base build (use existing)

set -e

# ─── Config ───────────────────────────────────────────────────────────────────
IMAGE_NAME="huchukato/comfyui-qwenvl-runpod"
BASE_IMAGE_NAME="huchukato/comfyui-base"
PLATFORM="linux/amd64"
DOCKER_DIR="$(cd "$(dirname "$0")/runpod" && pwd)"
BASE_DIR="$DOCKER_DIR/base"

# Base targets: name | cuda_dash | torch_suffix | trt_suffix | llama_wheel | torch_ver | torchvision_ver | torchaudio_ver
declare -a BASE_TARGETS=(
    "cu130|13-0|cu130|cu13|https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.48-cu131-linux-20260821/llama_cpp_python-0.3.48%2Bcu131-cp312-cp312-linux_x86_64.whl|2.10.0+cu130|0.25.0+cu130|2.10.0+cu130"
    "cu128|12-8|cu128|cu12|https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.48-cu128-linux-20260821/llama_cpp_python-0.3.48%2Bcu128-cp312-cp312-linux_x86_64.whl|2.10.0+cu128|0.25.0+cu128|2.10.0+cu128"
)

# Worker targets: name | dockerfile | tag | base_image
declare -a TARGETS=(
    "cu13-wan22|Dockerfile.CU13-WAN22|cu13-wan22|cu130"
    "cu128-wan22|Dockerfile.CU128-WAN22|cu128-wan22|cu128"
    "cu13-ltx23|Dockerfile.CU13-LTX23|cu13-ltx23|cu130"
    "cu13-ltx25|Dockerfile.CU13-LTX25|cu13-ltx25|cu130"
    "cu13-mmh3|Dockerfile.CU13-MMH3|cu13-mmh3|cu130"
    "cu13-umeairt|Dockerfile.CU13-UmeAiRT|cu13-umeairt|cu130"
)

# ─── Parse args ───────────────────────────────────────────────────────────────
NO_CACHE=""
SKIP_BASE=""
BASE_ONLY=""
SELECTED=()

for arg in "$@"; do
    case "$arg" in
        --no-cache) NO_CACHE="--no-cache" ;;
        --skip-base) SKIP_BASE=1 ;;
        --base-only) BASE_ONLY=1 ;;
        --help|-h)
            echo "Usage: $0 [target ...] [--no-cache] [--skip-base] [--base-only]"
            echo ""
            echo "Base targets:"
            echo "  cu130  (CUDA 13.0 / Blackwell)"
            echo "  cu128  (CUDA 12.8 / Ada)"
            echo ""
            echo "Worker targets:"
            for t in "${TARGETS[@]}"; do
                name="${t%%|*}"
                echo "  $name"
            done
            echo "  all (default)"
            echo ""
            echo "Aliases:"
            echo "  ltx23 -> cu13-ltx23"
            echo "  ltx25 -> cu13-ltx25"
            echo "  mmh3  -> cu13-mmh3"
            echo ""
            echo "Flags:"
            echo "  --skip-base   Skip base image build (use existing local image)"
            echo "  --base-only   Build only base images, skip workers"
            exit 0
            ;;
        *)
            case "$arg" in
                ltx23) SELECTED+=("cu13-ltx23") ;;
                ltx25) SELECTED+=("cu13-ltx25") ;;
                mmh3) SELECTED+=("cu13-mmh3") ;;
                *) SELECTED+=("$arg") ;;
            esac
            ;;
    esac
done

# ─── Preflight ────────────────────────────────────────────────────────────────
echo "🌋 ComfyUI-Garage — One Script to Build Them All"
echo ""

if [ ! -d "$DOCKER_DIR" ]; then
    echo "❌ Docker dir not found: $DOCKER_DIR"
    exit 1
fi

# Check Docker login
echo "🔐 Checking Docker Hub login..."
if ! docker login 2>&1 | grep -q "Login Succeeded\|Already logged in"; then
    echo "❌ Not logged in to Docker Hub. Run 'docker login' first."
    exit 1
fi
echo "✅ Docker Hub login confirmed"

# Setup buildx
echo "🔧 Using desktop-linux builder..."
docker buildx use --global desktop-linux 2>/dev/null || true

# Check latest ComfyUI version (informational only)
LATEST=$(curl -sL "https://api.github.com/repos/comfyanonymous/ComfyUI/tags?per_page=1" | grep -o '"name": "[^"]*' | head -1 | cut -d'"' -f4)
BAKED=$(sed -n 's/^variable "COMFYUI_VERSION" {/,/}/p' "$BASE_DIR/docker-bake.hcl" | grep default | head -1 | sed 's/.*"\(.*\)".*/\1/')
if [ -n "$LATEST" ]; then
    echo "📌 ComfyUI: baked=$BAKED latest=$LATEST"
    if [ "$LATEST" != "$BAKED" ]; then
        echo "   ⚠️  Base has $BAKED but latest is $LATEST — update docker-bake.hcl to match."
    fi
else
    echo "⚠️ Could not fetch latest ComfyUI tag, baked=$BAKED"
fi
echo ""

# ─── Build base images ────────────────────────────────────────────────────────
BUILT=0
FAILED=0

if [ -z "$SKIP_BASE" ]; then
    for bt in "${BASE_TARGETS[@]}"; do
        IFS='|' read -r bname cuda_dash torch_suffix trt_suffix llama_wheel torch_ver torchvision_ver torchaudio_ver <<< "$bt"

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🏗️  Building base: $bname"
        echo "   Dockerfile: base/Dockerfile.base"
        echo "   Tag:        ${BASE_IMAGE_NAME}:${bname}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        if docker buildx build --builder desktop-linux \
            --platform "$PLATFORM" \
            $NO_CACHE \
            -f "$BASE_DIR/Dockerfile.base" \
            -t "${BASE_IMAGE_NAME}:${bname}" \
            --build-arg CUDA_VERSION_DASH="$cuda_dash" \
            --build-arg TORCH_INDEX_SUFFIX="$torch_suffix" \
            --build-arg TENSORRT_SUFFIX="$trt_suffix" \
            --build-arg LLAMA_CPP_WHEEL_URL="$llama_wheel" \
            --build-arg TORCH_VERSION="$torch_ver" \
            --build-arg TORCHVISION_VERSION="$torchvision_ver" \
            --build-arg TORCHAUDIO_VERSION="$torchaudio_ver" \
            --load \
            "$BASE_DIR"; then

            echo "🚀 Pushing ${BASE_IMAGE_NAME}:${bname}..."
            docker push "${BASE_IMAGE_NAME}:${bname}"
            echo "✅ Done: ${BASE_IMAGE_NAME}:${bname}"
            BUILT=$((BUILT + 1))
        else
            echo "❌ Base build failed: $bname"
            FAILED=$((FAILED + 1))
        fi
        echo ""
    done
else
    echo "⏭️  Skipping base build (--skip-base)"
    echo ""
fi

# ─── Build worker images ──────────────────────────────────────────────────────
if [ -z "$BASE_ONLY" ]; then
    for target in "${TARGETS[@]}"; do
        IFS='|' read -r name dockerfile tag base <<< "$target"

        # Skip if specific targets selected and this isn't one
        if [ ${#SELECTED[@]} -gt 0 ]; then
            skip=true
            for s in "${SELECTED[@]}"; do
                [[ "$s" == "$name" || "$s" == "all" ]] && skip=false && break
            done
            $skip && continue
        fi

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🏗️  Building: $name (FROM ${BASE_IMAGE_NAME}:${base})"
        echo "   Dockerfile: $dockerfile"
        echo "   Tag:        ${IMAGE_NAME}:${tag}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        if [ ! -f "$DOCKER_DIR/$dockerfile" ]; then
            echo "❌ Dockerfile not found: $DOCKER_DIR/$dockerfile"
            FAILED=$((FAILED + 1))
            continue
        fi

        # Ensure base image exists locally
        if ! docker image inspect "${BASE_IMAGE_NAME}:${base}" >/dev/null 2>&1; then
            echo "⚠️  Base image ${BASE_IMAGE_NAME}:${base} not found locally, pulling..."
            docker pull "${BASE_IMAGE_NAME}:${base}" || {
                echo "❌ Cannot pull base ${BASE_IMAGE_NAME}:${base}. Build it first with --base-only"
                FAILED=$((FAILED + 1))
                continue
            }
        fi

        if docker buildx build --builder desktop-linux \
            --platform "$PLATFORM" \
            $NO_CACHE \
            --build-arg CACHEBUST="$(date +%s)" \
            -f "$DOCKER_DIR/$dockerfile" \
            -t "${IMAGE_NAME}:${tag}" \
            --load \
            "$DOCKER_DIR"; then

            echo "🚀 Pushing ${IMAGE_NAME}:${tag}..."
            docker push "${IMAGE_NAME}:${tag}"
            echo "✅ Done: ${IMAGE_NAME}:${tag}"
            BUILT=$((BUILT + 1))
        else
            echo "❌ Build failed: $name"
            FAILED=$((FAILED + 1))
        fi
        echo ""
    done
fi

# ─── Summary ──────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════╗"
echo "║  🏰 Build complete                                    ║"
echo "║  ✅ Built:  $BUILT                                      "
echo "║  ❌ Failed: $FAILED                                     "
echo "╚══════════════════════════════════════════════════════╝"

[ $FAILED -gt 0 ] && exit 1
exit 0
