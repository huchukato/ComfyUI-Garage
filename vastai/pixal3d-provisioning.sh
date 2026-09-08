#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

APT_PACKAGES=(
)

PIP_PACKAGES=(
    "tensorrt-cu13==10.15.1.29"
    "tensorrt-cu13-bindings==10.15.1.29"
    "tensorrt-cu13-libs==10.15.1.29"
)

NODES=(
    "https://github.com/Comfy-Org/ComfyUI-Manager"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto"
    "https://github.com/huchukato/ComfyUI-TagForge"
    "https://github.com/huchukato/ComfyUI-HuggingFace"
    "https://github.com/kijai/ComfyUI-KJNodes"
)

WORKFLOWS=(
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pixal3d/3d_pixal3d_trellis2_image_to_model.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-Wildcards-HiresFix.json"
    "https://github.com/huchukato/ComfyUI-Garage/raw/master/workflows/pony/PimpMyPony-TagComplete-FaceDet.json"
)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
)

# All models use pipe-delimited format: subdir|filename|url|min_size_bytes
MODELS=(
    "diffusion_models|pixal3d_int8_convrot.safetensors|https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/diffusion_models/pixal3d_int8_convrot.safetensors|3000000000"
    "diffusion_models|trellis_2_int8_convrot.safetensors|https://huggingface.co/Comfy-Org/TRELLIS.2/resolve/main/diffusion_models/trellis_2_int8_convrot.safetensors|3000000000"
    "vae|trellis_2_texture_vae_bf16.safetensors|https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_texture_vae_bf16.safetensors|200000000"
    "vae|trellis_2_shape_vae_bf16.safetensors|https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_shape_vae_bf16.safetensors|200000000"
    "clip_vision|dino_v3_L_naf_fp32.safetensors|https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/clip_vision/dino_v3_L_naf_fp32.safetensors|1000000000"
    "geometry_estimation|moge_2_vitl_normal_fp16.safetensors|https://huggingface.co/Comfy-Org/MoGe/resolve/main/geometry_estimation/moge_2_vitl_normal_fp16.safetensors|500000000"
    "background_removal|birefnet.safetensors|https://huggingface.co/Comfy-Org/BiRefNet/resolve/main/background_removal/birefnet.safetensors|150000000"
)

# Input asset for the workflow
INPUT_ASSETS=(
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/refs/heads/main/input/viking_wolf_rune_axe.png"
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
    
    echo "Downloading workflows..."
    WF_BASE="${COMFYUI_DIR}/user/default/workflows"
    for url in "${WORKFLOWS[@]}"; do
        rel="${url#*workflows/}"
        subdir=$(dirname "$rel")
        mkdir -p "$WF_BASE/$subdir"
        provisioning_download "$url" "$WF_BASE/$subdir"
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

    echo "Downloading models..."
    provisioning_get_hf_models "${MODELS[@]}"
        
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

function provisioning_get_hf_models() {
    # Downloads models specified in pipe-delimited format:
    # "subdir|filename|url|min_size_bytes"
    # Supports size-check to skip already-downloaded files and resume.
    if [[ -z $1 ]]; then return 1; fi

    local arr=("$@")
    local failures=0
    local count=0
    local total=${#arr[@]}
    echo "Downloading $total model(s)..."

    for entry in "${arr[@]}"; do
        ((count++))
        IFS='|' read -r subdir name url min_size <<< "$entry"
        local dest_dir="${COMFYUI_DIR}/models/${subdir}"
        local dest="${dest_dir}/${name}"
        mkdir -p "$dest_dir"

        # Skip if already present and large enough
        if [[ -f "$dest" ]]; then
            local size
            size=$(stat -c%s "$dest" 2>/dev/null || stat -f%z "$dest" 2>/dev/null || echo 0)
            if [[ "$size" -ge "$min_size" ]]; then
                echo "[$count/$total] $name already present ($size bytes), skipping"
                continue
            else
                echo "[$count/$total] $name incomplete ($size < $min_size), re-downloading..."
            fi
        fi

        echo "[$count/$total] Downloading $name..."
        local max_retries=3
        local success=false
        for attempt in $(seq 1 $max_retries); do
            if provisioning_download "$url" "$dest_dir"; then
                # Verify size after download
                if [[ -f "$dest" ]]; then
                    local size
                    size=$(stat -c%s "$dest" 2>/dev/null || stat -f%z "$dest" 2>/dev/null || echo 0)
                    if [[ "$size" -ge "$min_size" ]]; then
                        echo "  $name downloaded ($size bytes)"
                        success=true
                        break
                    else
                        echo "  $name size $size < $min_size (attempt $attempt/$max_retries)"
                    fi
                else
                    echo "  $name file not found after download (attempt $attempt/$max_retries)"
                fi
            else
                echo "  Download failed for $name (attempt $attempt/$max_retries)"
            fi
            [[ "$attempt" -lt "$max_retries" ]] && sleep $((attempt * 5))
        done

        if [[ "$success" != "true" ]]; then
            echo "  FAILED: $name after $max_retries attempts"
            failures=$((failures + 1))
        fi
    done

    echo "Models download finished ($failures failure(s))"
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
