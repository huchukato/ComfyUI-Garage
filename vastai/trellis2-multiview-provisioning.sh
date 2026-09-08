#!/bin/bash

# ============================================================================
# Trellis 2 Multi-View provisioning for VastAI
# EXPERIMENTAL: uses visualbruno/ComfyUI-Trellis2 with compiled wheels
# Wheel compatibility: Torch 2.9.1 / Python 3.12 / Linux x86_64
# If your environment differs, the wheel install may fail and the script
# will attempt to build the native extensions from source (slow, ~10-15 min).
# ============================================================================

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

APT_PACKAGES=(
    "libgl1-mesa-glx"
    "libglib2.0-0"
)

PIP_PACKAGES=(
    "tensorrt-cu13==10.15.1.29"
    "tensorrt-cu13-bindings==10.15.1.29"
    "tensorrt-cu13-libs==10.15.1.29"
    "trimesh"
    "easydict"
    "plyfile"
    "zstandard"
    "meshlib"
    "pymeshlab"
    "opencv-python"
    "scipy"
    "open3d"
    "plotly"
    "rembg"
)

NODES=(
    "https://github.com/Comfy-Org/ComfyUI-Manager"
    "https://github.com/visualbruno/ComfyUI-Trellis2"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-TagForge"
    "https://github.com/huchukato/ComfyUI-HuggingFace"
    "https://github.com/kijai/ComfyUI-KJNodes"
)

# Multi-view workflows from visualbruno + Pony workflows
WORKFLOWS=(
    "https://raw.githubusercontent.com/visualbruno/ComfyUI-Trellis2/main/example_workflows/Simple_MultiView.json"
    "https://raw.githubusercontent.com/visualbruno/ComfyUI-Trellis2/main/example_workflows/Simple_MultiView_Pixal3D.json"
    "https://raw.githubusercontent.com/visualbruno/ComfyUI-Trellis2/main/example_workflows/MeshOnly_MultiView.json"
    "https://raw.githubusercontent.com/visualbruno/ComfyUI-Trellis2/main/example_workflows/MeshOnly_MultiView_Pixal3D.json"
    "https://raw.githubusercontent.com/visualbruno/ComfyUI-Trellis2/main/example_workflows/MeshTexturing_MultiView.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards-HiresFix.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-FaceDet.json"
)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
)

# Trellis 2 models are auto-downloaded by the Load Model node on first run.
# We only pre-download the DINOv3 model which must be cloned from HuggingFace.
MODELS=(
)

INPUT_ASSETS=(
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/refs/heads/main/input/viking_wolf_rune_axe.png"
)

# Wheel base URL for Linux cp312 (Torch 2.9.1 build, closest to our env)
WHEEL_BASE="https://github.com/visualbruno/ComfyUI-Trellis2/raw/main/wheels/Linux/Torch291"
WHEELS=(
    "cumesh-1.0-cp312-cp312-linux_x86_64.whl"
    "custom_rasterizer-0.1-cp312-cp312-linux_x86_64.whl"
    "flex_gemm-0.0.1-cp312-cp312-linux_x86_64.whl"
    "nvdiffrast-0.4.0-cp312-cp312-linux_x86_64.whl"
    "nvdiffrec_render-0.0.0-cp312-cp312-linux_x86_64.whl"
    "o_voxel-0.0.1-cp312-cp312-linux_x86_64.whl"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    echo "Starting provisioning process..."

    echo "Installing APT packages..."
    provisioning_get_apt_packages

    echo "Installing custom nodes..."
    provisioning_get_nodes

    echo "Installing PIP packages..."
    provisioning_get_pip_packages

    echo "Installing Trellis2 native wheels..."
    provisioning_install_trellis2_wheels

    echo "Cloning DINOv3 model from HuggingFace..."
    provisioning_clone_dinov3

    echo "Downloading workflows..."
    WF_BASE="${COMFYUI_DIR}/user/default/workflows"
    for url in "${WORKFLOWS[@]}"; do
        filename=$(basename "$url")
        mkdir -p "$WF_BASE/trellis2-multiview"
        provisioning_download "$url" "$WF_BASE/trellis2-multiview"
    done
    # Pony workflows go to their own subfolder
    for f in PimpMyPony-*.json; do
        if [[ -f "$WF_BASE/trellis2-multiview/$f" ]]; then
            mkdir -p "$WF_BASE/pony"
            mv "$WF_BASE/trellis2-multiview/$f" "$WF_BASE/pony/"
        fi
    done
    echo "Workflows downloaded to: $WF_BASE"

    # Download input assets
    echo "Downloading input assets..."
    INPUT_DIR="${COMFYUI_DIR}/input"
    mkdir -p "$INPUT_DIR"
    for url in "${INPUT_ASSETS[@]}"; do
        provisioning_download "$url" "$INPUT_DIR"
    done
    echo "Input assets downloaded to: $INPUT_DIR"

    provisioning_print_end
}

function provisioning_install_trellis2_wheels() {
    local wheel_dir="/tmp/trellis2_wheels"
    mkdir -p "$wheel_dir"
    local all_ok=true

    echo "Downloading prebuilt wheels..."
    for whl in "${WHEELS[@]}"; do
        wget -q -P "$wheel_dir" "${WHEEL_BASE}/${whl}" || true
    done

    echo "Installing wheels (best-effort)..."
    for whl in "${WHEELS[@]}"; do
        local path="${wheel_dir}/${whl}"
        if [[ -f "$path" ]]; then
            if pip install --root-user-action=ignore --no-cache-dir --no-deps "$path" 2>/dev/null; then
                echo "  OK: $whl"
            else
                echo "  FAIL: $whl (will try source build)"
                all_ok=false
            fi
        else
            echo "  MISSING: $whl"
            all_ok=false
        fi
    done

    if [[ "$all_ok" != "true" ]]; then
        echo ""
        echo "Some wheels failed. Attempting source build..."
        provisioning_build_trellis2_from_source
    fi

    rm -rf "$wheel_dir"
}

function provisioning_build_trellis2_from_source() {
    # Build native extensions from visualbruno/TRELLIS.2 source
    local trellis_src="/tmp/TRELLIS2_src"

    # Ensure CUDA toolkit is available
    if ! command -v nvcc &>/dev/null; then
        echo "WARNING: nvcc not found. Trying to find CUDA toolkit..."
        for cuda_dir in /usr/local/cuda /usr/local/cuda-13.0 /usr/local/cuda-12.8 /usr/local/cuda-12.4; do
            if [[ -f "${cuda_dir}/bin/nvcc" ]]; then
                export PATH="${cuda_dir}/bin:$PATH"
                export CUDA_HOME="$cuda_dir"
                echo "  Found CUDA at $cuda_dir"
                break
            fi
        done
    fi

    if ! command -v nvcc &>/dev/null; then
        echo "ERROR: Cannot find nvcc. Native extension build will fail."
        echo "Trellis2 multi-view nodes may not work."
        return 1
    fi

    echo "Cloning TRELLIS.2 source for native builds..."
    git clone --depth 1 https://github.com/visualbruno/TRELLIS.2.git "$trellis_src" 2>/dev/null || true

    # Detect GPU arch
    local gpu_arch
    gpu_arch=$(python3 -c "import torch; print(torch.cuda.get_device_capability()[0]*10 + torch.cuda.get_device_capability()[1])" 2>/dev/null || echo "89")
    export TORCH_CUDA_ARCH_LIST="${gpu_arch:0:1}.${gpu_arch:1:1}"
    echo "  Building for CUDA arch: $TORCH_CUDA_ARCH_LIST"

    # Build each extension
    local extensions=("o-voxel" "flex-gemm" "cumesh")
    for ext in "${extensions[@]}"; do
        local ext_dir="${trellis_src}/${ext}"
        if [[ -d "$ext_dir" ]]; then
            echo "  Building $ext..."
            pip install --root-user-action=ignore --no-cache-dir "$ext_dir" 2>&1 | tail -5
        else
            echo "  $ext source not found, skipping"
        fi
    done

    # nvdiffrast from PyPI or source
    pip install --root-user-action=ignore --no-cache-dir nvdiffrast 2>/dev/null || echo "  nvdiffrast install failed"

    rm -rf "$trellis_src"
}

function provisioning_clone_dinov3() {
    # DINOv3 model required by visualbruno's Trellis2 nodes
    local dinov3_dir="${COMFYUI_DIR}/models/facebook/dinov3-vitl16-pretrain-lvd1689m"
    if [[ -d "$dinov3_dir" ]]; then
        echo "  DINOv3 already present, skipping"
        return 0
    fi

    mkdir -p "${COMFYUI_DIR}/models/facebook"

    if command -v git-lfs &>/dev/null || git lfs version &>/dev/null 2>&1; then
        echo "  Cloning with git-lfs..."
        if [[ -n "$HF_TOKEN" ]]; then
            git clone "https://hf_token:${HF_TOKEN}@huggingface.co/facebook/dinov3-vitl16-pretrain-lvd1689m" "$dinov3_dir"
        else
            git clone "https://huggingface.co/facebook/dinov3-vitl16-pretrain-lvd1689m" "$dinov3_dir"
        fi
    else
        echo "  git-lfs not available, installing..."
        sudo apt-get install -y git-lfs 2>/dev/null || true
        git lfs install
        if [[ -n "$HF_TOKEN" ]]; then
            git clone "https://hf_token:${HF_TOKEN}@huggingface.co/facebook/dinov3-vitl16-pretrain-lvd1689m" "$dinov3_dir"
        else
            git clone "https://huggingface.co/facebook/dinov3-vitl16-pretrain-lvd1689m" "$dinov3_dir"
        fi
    fi
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
           echo "Installing PIP packages..."
           for package in "${PIP_PACKAGES[@]}"; do
               echo "Installing: $package"
               pip install --root-user-action=ignore --no-cache-dir $package
               echo "Completed: $package"
           done
           echo "All PIP packages installed successfully!"
    fi
}

function provisioning_get_nodes() {
    echo "Processing ${#NODES[@]} nodes..."
    local count=0
    for repo in "${NODES[@]}"; do
        ((count++))
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"

        echo "[$count/${#NODES[@]}] Processing node: $dir"

        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                echo "  Updating existing node..."
                local branch
                branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
                if git -C "$path" pull --ff-only origin "$branch" 2>/dev/null; then
                    echo "  $dir updated"
                else
                    echo "  $dir pull failed, resetting to origin/$branch..."
                    git -C "$path" fetch origin "$branch" 2>/dev/null && \
                        git -C "$path" reset --hard "origin/$branch" 2>/dev/null || \
                        echo "  $dir reset failed, leaving as-is"
                fi
                if [[ -e $requirements ]]; then
                   echo "  Installing requirements..."
                   pip install --root-user-action=ignore --no-cache-dir -r "$requirements"
                fi
            else
                echo "  Node exists, skipping (AUTO_UPDATE=false)"
            fi
        else
            echo "  Downloading new node..."
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                echo "  Installing requirements..."
                pip install --root-user-action=ignore --no-cache-dir -r "${requirements}"
            fi
        fi

    done
    echo "All nodes processed successfully!"
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#    Trellis2 Multi-View (EXPERIMENTAL)      #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" --content-disposition -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget --content-disposition -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
