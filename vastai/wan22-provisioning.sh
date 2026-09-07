#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

APT_PACKAGES=(
)

PIP_PACKAGES=(
    "--upgrade --force-reinstall --no-cache-dir https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.48-cu131-linux-20260821/llama_cpp_python-0.3.48+cu131-cp312-cp312-linux_x86_64.whl"
    "sageattention"
    "tensorrt_cu13==10.15.1.29"
    "tensorrt_cu13_bindings==10.15.1.29"
    "tensorrt_cu13_libs==10.15.1.29"
)

NODES=(
    "https://github.com/Comfy-Org/ComfyUI-Manager"
    "https://github.com/huchukato/comfy-tagcomplete"
    "https://github.com/huchukato/ComfyUI-QwenVL-Mod"
    "https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-HuggingFace"
    "https://github.com/MoonGoblinDev/Civicomfy"
    "https://github.com/Koishi-Star/Euler-Smea-Dyn-Sampler"
    "https://github.com/ltdrdata/was-node-suite-comfyui"
    "https://github.com/ltdrdata/comfyui-impact-pack"
    "https://github.com/ltdrdata/comfyui-impact-subpack"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/Smirnov75/ComfyUI-mxToolkit"
    "https://github.com/princepainter/ComfyUI-PainterI2V"
    "https://github.com/princepainter/ComfyUI-PainterLongVideo"
    "https://github.com/ashtar1984/comfyui-find-perfect-resolution"
    "https://github.com/huchukato/ComfyUI-Selectors"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/kijai/ComfyUI-MMAudio"
    "https://github.com/GACLove/ComfyUI-VFI"
    "https://github.com/stduhpf/ComfyUI-WanMoeKSampler"
    "https://github.com/melMass/comfy_mtb"
    "https://github.com/huchukato/ComfyUI-PerfectVideoResolution"
)

WORKFLOWS=(
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-FL2V-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-I2V-20s-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-I2V-20s-Story-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-I2V-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-I2V-SVI-20s-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-I2V-SVI-20s-Story-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-T2V-I2V-Story-Qwen3.5.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/wan22/WAN2.2-T2V-Qwen3.5.json"
)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
   
)

DIFFUSION_MODELS=(
    "diffusion_models|wan22RemixT2VI2V_i2vHighV30.safetensors|https://huggingface.co/huchukato/garage/resolve/main/diffusion_models/wan22RemixT2VI2V_i2vHighV30.safetensors|14000000000"
    "diffusion_models|wan22RemixT2VI2V_i2vLowV30.safetensors|https://huggingface.co/huchukato/garage/resolve/main/diffusion_models/wan22RemixT2VI2V_i2vLowV30.safetensors|14000000000"
    "diffusion_models|wan22RemixT2VI2V_t2vHighV20.safetensors|https://huggingface.co/huchukato/garage/resolve/main/diffusion_models/wan22RemixT2VI2V_t2vHighV20.safetensors|14000000000"
    "diffusion_models|wan22RemixT2VI2V_t2vLowV20.safetensors|https://huggingface.co/huchukato/garage/resolve/main/diffusion_models/wan22RemixT2VI2V_t2vLowV20.safetensors|14000000000"
)

LORA_MODELS=(
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_HIGH_lora_rank_128_fp16.safetensors"
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_LOW_lora_rank_128_fp16.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
    "https://huggingface.co/huchukato/garage/resolve/main/vae/sdxl.vae.safetensors"
)

ESRGAN_MODELS=(
    "https://huggingface.co/huchukato/garage/resolve/main/esrgan/2xLexicaRRDBNet.pth"
    "https://huggingface.co/huchukato/garage/resolve/main/esrgan/2xLexicaRRDBNet_Sharp.pth"
)

TEXT_ENCODERS=(
    "https://huggingface.co/NSFW-API/NSFW-Wan-UMT5-XXL/resolve/main/nsfw_wan_umt5-xxl_fp8_scaled.safetensors"
)

CONTROLNET_MODELS=(
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

    # ── Download PMP wildcards from Garage (single zip, ~120KB) ──
    echo "🎲 Downloading PMP wildcards zip from Garage..."
    WILDCARD_DIR="${COMFYUI_DIR}/custom_nodes/comfy-tagcomplete/wildcards"
    WILDCARD_ZIP_URL="https://github.com/huchukato/ComfyUI-Garage/raw/master/wildcards/pmp-wildcards.zip"
    mkdir -p "$WILDCARD_DIR"
    if wget -q --tries=3 --timeout=30 "$WILDCARD_ZIP_URL" -O "$WILDCARD_DIR/pmp-wildcards.zip"; then
        unzip -oq "$WILDCARD_DIR/pmp-wildcards.zip" -d "$WILDCARD_DIR"
        rm -f "$WILDCARD_DIR/pmp-wildcards.zip"
        echo "✅ PMP wildcards extracted to $WILDCARD_DIR/pmp"
    else
        echo "❌ PMP wildcards zip download failed"
    fi

    echo "🎯 Downloading checkpoint models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
        
    echo "🧠 Downloading U-NET models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
        
    echo "🔮 Downloading diffusion models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}"
        
    echo "🎨 Downloading LoRA models..."
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
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
    COMFYUI_PATH="${COMFYUI_DIR}" COMFYUI_MODEL_PATH="${COMFYUI_DIR}/models" python "${COMFYUI_DIR}/custom_nodes/comfyui-impact-pack/install.py"
    [[ -d "${COMFYUI_DIR}/custom_nodes/comfyui-impact-pack" ]] && rm -rf "${COMFYUI_DIR}/custom_nodes/ComfyUI-Impact-Pack"
    [[ -d "${COMFYUI_DIR}/custom_nodes/comfyui-impact-subpack" ]] && rm -rf "${COMFYUI_DIR}/custom_nodes/ComfyUI-Impact-Subpack"
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

    # Check if the token is valid
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

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\\.)?huggingface\\.co(/|$|\\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\\.)?civitai\\.com(/|$|\\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
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
