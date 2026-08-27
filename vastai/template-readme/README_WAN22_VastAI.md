![ComfyUI-QwenVL-Mod WAN 2.2](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-wan22-cu132-v.jpg)

# Vast.ai - ComfyUI - WAN 2.2 Uncensored - Qwen3.5

Custom ComfyUI on Vast.ai, provisioned with QwenVL-Mod and WAN 2.2 video generation with Qwen3-VL auto-prompting.

**Template**: Vast.ai ComfyUI template + `vastai/wan22-provisioning.sh`

**Provisioning script**: `vastai/wan22-provisioning.sh`

---

## 🚀 Features

- **WAN 2.2 Video**: T2V, I2V, Storyboard, MMAudio workflows
- **Multilingual prompts** with visual style detection
- **GGUF backend** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, async offload
- **TensorRT** upscaling and frame interpolation
- **Persistent** `/workspace` (models survive restarts)

---

## 📦 What's Included

### Base Template (Vast.ai ComfyUI)
CUDA 13.0, PyTorch, Python 3.12, ComfyUI core, ComfyUI-Manager.

### Custom Nodes (24, installed by provisioning)
ComfyUI-Manager, QwenVL-Mod, RIFE-TensorRT-Auto, Upscaler-TensorRT-Auto, HuggingFace, Civicomfy, Euler-Smea-Dyn-Sampler, was-node-suite, VideoHelperSuite, rgthree-comfy, Easy-Use, Frame-Interpolation, mxToolkit, PainterI2V, PainterLongVideo, find-perfect-resolution, Selectors, GGUF, MMAudio, VFI, WanMoeKSampler, comfy_mtb, comfy-tagcomplete, ComfyUI-Crystools-MonitorOnly.

### Models auto-downloaded at provisioning (~35 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `vae` | `wan_2.1_vae.safetensors` | Comfy-Org/Wan_2.2_ComfyUI_Repackaged | ~500 MB |
| `vae` | `sdxl.vae.safetensors` | huchukato/favs | ~250 MB |
| `upscale_models` | `2xLexicaRRDBNet.pth` | huchukato/favs | ~65 MB |
| `upscale_models` | `2xLexicaRRDBNet_Sharp.pth` | huchukato/favs | ~65 MB |
| `text_encoders` | `nsfw_wan_umt5-xxl_fp8_scaled.safetensors` | NSFW-API/NSFW-Wan-UMT5-XXL (uncensored) | ~5 GB |
| `diffusion_models` | `wan22RemixT2VI2V_i2vHighV30.safetensors` | huchukato/pimp-my-wan | ~14 GB |
| `diffusion_models` | `wan22RemixT2VI2V_i2vLowV30.safetensors` | huchukato/pimp-my-wan | ~14 GB |

> Models download during provisioning. ComfyUI starts after provisioning completes. No re-download on restart.

### Workflows (13, downloaded by provisioning)
WAN 2.2 T2V/I2V/SVI (GGUF variants), Full MMAudio, AutoPrompt Story, PMP LoRaStack.

---

## 🛠️ Requirements

- **GPU**: RTX 5090 / 4090 or any CUDA 13.0 card
- **VRAM**: 24GB+ recommended
- **Storage**: 100GB+ SSD
- **Vast.ai template**: ComfyUI (CUDA 13.0)

---

## 🔑 Environment Variables

Set in Vast.ai template launch options:

```
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🚀 Quick Start

1. **Launch**: Select Vast.ai ComfyUI template (CUDA 13.0)
2. **Provisioning**: Set `vastai/wan22-provisioning.sh` as the launch script
3. **First boot**: Provisioning installs nodes, workflows, and downloads models
4. **Load workflow**: `ComfyUI > Load > WAN2.2-*.json`
5. **Access**: ComfyUI on the assigned port (check Vast.ai instance details)

---

## ⚙️ ComfyUI Args

Add to ComfyUI launch arguments:
```
--fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🔄 Persistence

`/workspace/ComfyUI` survives restarts: models, nodes, workflows, output, user data. No re-downloads on restart.

---

## 🐳 vs RunPod

| | Vast.ai | RunPod |
|---|---|---|
| **Setup** | Provisioning script | Docker image |
| **ComfyUI path** | `/workspace/ComfyUI` | `/workspace/runpod-slim/ComfyUI` |
| **Pre-baked models** | No (all at provisioning) | Yes (VAE, upscalers, text encoder) |
| **FileBrowser/Jupyter** | Not included | Included |
| **Cost** | Per-hour, cheaper | Per-hour, fixed |
| **CUDA** | 13.0 | 12.8 or 13.0 |

---

Based on the Vast.ai ComfyUI template with QwenVL-Mod and WAN 2.2 enhancements.
