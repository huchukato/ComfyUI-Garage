#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

APT_PACKAGES=(
    "aria2"
)

PIP_PACKAGES=(
    "--upgrade --force-reinstall --no-cache-dir https://github.com/JamePeng/llama-cpp-python/releases/download/v0.4.2-cu131-linux-20261003/llama_cpp_python-0.4.2+cu131-cp312-cp312-linux_x86_64.whl"
    "huggingface_hub"
    "tensorrt-cu13==10.15.1.29"
    "tensorrt-cu13-bindings==10.15.1.29"
    "tensorrt-cu13-libs==10.15.1.29"
)

NODES=(
    "https://github.com/huchukato/ComfyUI-TagForge"
    "https://github.com/huchukato/ComfyUI-QwenVL-Mod"
    "https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-HuggingFace"
    "https://github.com/Koishi-Star/Euler-Smea-Dyn-Sampler"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/MoonGoblinDev/Civicomfy"
    "https://github.com/pixaroma/ComfyUI-Pixaroma"
    "https://github.com/Comfy-Org/Nvidia_RTX_Nodes_ComfyUI"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/huchukato/ComfyUI-PerfectVideoResolution"
    "https://github.com/huchukato/ComfyUI-Gallery"
)

WORKFLOWS=(
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/minimax/MiniMaxH3-Turbo-I2VA-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/minimax/MiniMaxH3-Turbo-FL2VA-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/minimax/MiniMaxH3-Turbo-T2VA-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/minimax/MiniMaxH3-Turbo-R2VA-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/minimax/MiniMaxH3-Singularity-R2VA-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/utils/2in1-LoRaStack-Merge.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/utils/Pony-XL-Outpaint.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/utils/RIFE-Upscale-TensorRT.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards-HiresFix.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-FaceDet.json"
)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
)

TEXT_ENCODERS=(
)

CONTROLNET_MODELS=(
)

# Large MiniMax H3 models downloaded via hf/huggingface-cli (format: subdir|name|url|min_size_bytes)
MINIMAX_MODELS=(
    "vae|minimax_h3_video_vae_fp16.safetensors|https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors|5200000000"
    "vae|minimax_h3_audio_vae_fp32.safetensors|https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors|600000000"
    # ── Tiny H3 VAE for fast previews (Kijai TAE) ──
    "vae_approx|taeh3.safetensors|https://huggingface.co/Kijai/MiniMax-H3-TAE/resolve/main/vae_approx/taeh3.safetensors|10000000"
    # ── Singularity pruned INT8 (WarmBloodAban) — fusion T2V/I2V/Ref2V/V2V ──
    "diffusion_models|Minimax-h3_Singularity_ref2va_Pruned_v1.3_int8.safetensors|https://huggingface.co/WarmBloodAban/Minimax-h3_Singularity/resolve/main/Minimax-h3_Singularity_ref2va_Pruned_v1.3_int8.safetensors|20000000000"
    # ── Full H3 conditioning TE: Ultra Heretic NVFP4 (uncensored, ethanfel) ──
    "text_encoders|qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors|https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4/resolve/main/qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors|15000000000"
    # ── Official alibaba-pai 8-step Acc LoRA for Ref2VA (rank 64, BF16) — the turbo used in Singularity test wf ──
    "loras|MiniMax-H3-Ref2VA-Acc-8Step.safetensors|https://huggingface.co/alibaba-pai/MiniMax-H3-Acc-LoRAs/resolve/main/MiniMax-H3-Ref2VA-Acc-8Step.safetensors|1300000000"
    # ── fal Realism People LoRA (rank 32, trigger word: r34l1sm) ──
    "loras|h3-realism-people-t2v-i2v-r2v.safetensors|https://huggingface.co/fal/MiniMax-H3-Realism-People-LoRA/resolve/main/h3-realism-people-t2v-i2v-r2v.safetensors|100000000"
    # ── ref2v Turbo 4-step (Comfy-Org official) — the LoRA Singularity recommends ──
    "loras|minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors|https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors|1900000000"
    # ── Kijai reference LoRA rank 256 — required for R2VA Native preset ──
    "loras|minimax_h3_ref_lora_rank_256_bf16.safetensors|https://huggingface.co/Kijai/MiniMax-H3-experimental/resolve/main/loras/minimax_h3_ref_lora_rank_256_bf16.safetensors|2500000000"
)


YOLO_MODELS=(
    "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt"
)

SAM_MODELS=(
    "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    echo "🚀 Starting provisioning process..."

    echo "📦 Installing APT packages..."
    provisioning_get_apt_packages

    echo "🔧 Installing custom nodes..."
    provisioning_get_nodes

    echo "📦 Installing PIP packages..."
    provisioning_get_pip_packages

    echo "📁 Downloading workflows..."
    WF_BASE="${COMFYUI_DIR}/user/default/workflows"
    for url in "${WORKFLOWS[@]}"; do
        rel="${url#*workflows/}"
        subdir=$(dirname "$rel")
        mkdir -p "$WF_BASE/$subdir"
        provisioning_download "$url" "$WF_BASE/$subdir"
    done

    echo "✅ Workflows downloaded to: $WF_BASE"

    # ── Download PMP wildcards from Garage (yaml files) ──
    echo "🔄 Downloading PMP wildcards from Garage..."
    WILDCARD_DIR="${COMFYUI_DIR}/custom_nodes/ComfyUI-TagForge/wildcards"
    WILDCARD_BASE="https://github.com/huchukato/ComfyUI-Garage/raw/master/wildcards"
    WILDCARD_FILES="pmp/act.yaml pmp/actff.yaml pmp/actffm.yaml pmp/actmmf.yaml pmp/actsolo.yaml pmp/blwjob.yaml pmp/prmpt.yaml pmp/qwen21.yaml pmp/prmpt/acc.yaml pmp/prmpt/char.yaml pmp/prmpt/clths.yaml pmp/prmpt/exprss.yaml pmp/prmpt/hair.yaml pmp/prmpt/imgcmp.yaml pmp/prmpt/lctns.yaml pmp/prmpt/light.yaml pmp/prmpt/pose.yaml pmp/prmpt/styles.yaml"
    for wf in $WILDCARD_FILES; do
        mkdir -p "$WILDCARD_DIR/$(dirname "$wf")"
        wget -q --tries=3 --timeout=30 "$WILDCARD_BASE/$wf" -O "$WILDCARD_DIR/$wf" || echo "⚠️ wildcard $wf download failed"
    done
    find "$WILDCARD_DIR/pmp" -name "*.txt" -delete 2>/dev/null
    echo "✅ PMP wildcards updated in $WILDCARD_DIR/pmp"

    echo "🎯 Downloading checkpoint models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"

    echo "🧠 Downloading U-NET models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"

    echo "🎨 Downloading LoRA models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/loras" \
        "${LORA_MODELS[@]}"

    echo "🎮 Downloading ControlNet models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"

    echo "🔮 Downloading VAE models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"

    echo "⚡ Downloading upscale models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/upscale_models" \
        "${ESRGAN_MODELS[@]}"

    echo "📝 Downloading text encoders..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}"

    echo "🎬 Downloading MiniMax H3 models (large files via hf)..."
    download_minimax_models

    echo "🔍 Downloading YOLO models..."
    mkdir -p "${COMFYUI_DIR}/models/ultralytics/bbox"
    provisioning_get_files         "${COMFYUI_DIR}/models/ultralytics/bbox"         "${YOLO_MODELS[@]}"
        
    echo "🧩 Downloading SAM models..."
    mkdir -p "${COMFYUI_DIR}/models/sams"
    provisioning_get_files         "${COMFYUI_DIR}/models/sams"         "${SAM_MODELS[@]}"
        
    provisioning_print_end
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
            echo "✓ Completed: $package"
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
                echo "  → Updating existing node..."
                local branch
                branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
                if git -C "$path" pull --ff-only origin "$branch" 2>/dev/null; then
                    echo "  ✅ $dir updated"
                else
                    echo "  ⚠️  $dir pull failed, resetting to origin/$branch..."
                    git -C "$path" fetch origin "$branch" 2>/dev/null && \
                        git -C "$path" reset --hard "origin/$branch" 2>/dev/null || \
                        echo "  ⚠️  $dir reset failed, leaving as-is"
                fi
                if [[ -e $requirements ]]; then
                    echo "  → Installing requirements..."
                    pip install --root-user-action=ignore --no-cache-dir -r "$requirements"
                fi
            else
                echo "  → Node exists, skipping (AUTO_UPDATE=false)"
            fi
        else
            echo "  → Downloading new node..."
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                echo "  → Installing requirements..."
                pip install --root-user-action=ignore --no-cache-dir -r "${requirements}"
            fi
        fi

    done
    echo "All nodes processed successfully!"
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi

    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    echo "Downloading ${#arr[@]} file(s) to $dir..."
    local count=0
    for url in "${arr[@]}"; do
        ((count++))
        echo "[$count/${#arr[@]}] Downloading: $(basename "$url")"
        provisioning_download "${url}" "${dir}"
        echo "  ✓ Download completed"
    done
    echo "All files downloaded successfully!"
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
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

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" --content-disposition -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget --content-disposition -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Polls the temp dir size while hf/hf_transfer downloads (hf_transfer emits no
# parseable progress), printing a bar + % + MB every 20s.
function monitor_progress() {
    local watch_dir="$1" expected="$2" name="$3"
    local cur pct filled pad bar exp_mb
    exp_mb=$(( expected / 1048576 ))
    while :; do
        cur=$(du -sb "$watch_dir" 2>/dev/null | awk '{print $1}')
        cur=${cur:-0}
        pct=$(( cur * 100 / expected ))
        [ "$pct" -gt 100 ] && pct=100
        filled=$(( pct / 5 ))
        printf -v bar '%*s' "$filled" ''; bar=${bar// /#}
        printf -v pad '%*s' "$((20 - filled))" ''; pad=${pad// /-}
        echo "   ⏳ $name [${bar}${pad}] ${pct}% ($((cur / 1048576))/${exp_mb} MB)"
        sleep 20
    done
}

function download_minimax_models() {
    local base_dir="${COMFYUI_DIR}/models"
    mkdir -p "$base_dir"/{vae,vae_approx,diffusion_models,text_encoders,clip_projections,loras}

    local hf_cmd="hf"
    command -v hf >/dev/null 2>&1 || hf_cmd="huggingface-cli"

    for entry in "${MINIMAX_MODELS[@]}"; do
        IFS='|' read -r subdir name url min_size <<< "$entry"
        local dest="$base_dir/$subdir/$name"

        if [ -f "$dest" ] || [ -L "$dest" ]; then
            local size
            size=$(stat -L -c%s "$dest" 2>/dev/null || stat -L -f%z "$dest" 2>/dev/null || echo 0)
            if [ "$size" -ge "$min_size" ]; then
                echo "✅ $name already present ($size bytes >= $min_size), skipping"
                continue
            fi
        fi

        echo "📥 Downloading $name ..."
        local repo_id repo_path tmp_dir
        repo_id=$(echo "$url" | awk -F/ '{print $4"/"$5}')
        repo_path=$(echo "$url" | sed -E 's#https?://[^/]+/[^/]+/[^/]+/resolve/main/(.+)#\1#')
        tmp_dir="$base_dir/.tmp_download_${name//\//_}"
        rm -rf "$tmp_dir"
        mkdir -p "$tmp_dir"

        export HF_HUB_ENABLE_HF_TRANSFER=1
        export HF_XET_HIGH_PERFORMANCE=1
        local resume_flag=""
        [ "$hf_cmd" = "huggingface-cli" ] && resume_flag="--resume-download"

        monitor_progress "$tmp_dir" "$min_size" "$name" &
        local mon_pid=$!

        if $hf_cmd download "$repo_id" "$repo_path" --local-dir "$tmp_dir" $resume_flag; then
            kill "$mon_pid" 2>/dev/null; wait "$mon_pid" 2>/dev/null
            local downloaded_path="$tmp_dir/$repo_path"
            if [ -f "$downloaded_path" ] || [ -L "$downloaded_path" ]; then
                mv -f "$downloaded_path" "$dest"
                rm -rf "$tmp_dir"
                local size
                size=$(stat -L -c%s "$dest" 2>/dev/null || stat -L -f%z "$dest" 2>/dev/null || echo 0)
                echo "✅ $name downloaded successfully ($size bytes)"
            else
                echo "⚠️  $name not found after download"
                rm -rf "$tmp_dir"
            fi
        else
            kill "$mon_pid" 2>/dev/null; wait "$mon_pid" 2>/dev/null
            echo "❌ $hf_cmd failed for $name"
            rm -rf "$tmp_dir"
        fi
    done
}

if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
