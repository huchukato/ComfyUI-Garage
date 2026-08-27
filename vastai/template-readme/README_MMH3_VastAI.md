![ComfyUI-QwenVL-Mod MiniMax H3](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-mmh3-cu13-v.jpg)

# Vast.ai - ComfyUI - MiniMax H3 Uncensored - Qwen3.5

Custom ComfyUI on Vast.ai, provisioned with QwenVL-Mod and native MiniMax H3 video+audio generation with Qwen3-VL auto-prompting.

**Template**: Vast.ai ComfyUI template + `vastai/mmh3-provisioning.sh`

**Provisioning script**: `vastai/mmh3-provisioning.sh`

---

## 🚀 Features

- **MiniMax H3 native video+audio**: T2VA, I2VA, FL2VA / R2VA workflows
- **NVFP4 quantization** for Blackwell GPUs (RTX 5090 / PRO 6000)
- **SOL-ATTN** (Scheduled Sol Attention) for sharper Turbo output
- **Spectrum** adaptive smoothing for Turbo workflows
- **Built-in audio generation**: no separate MMAudio node required
- **Multilingual prompts** with visual style detection via QwenVL-Mod
- **GGUF backend** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, async offload
- **TensorRT** upscaling and frame interpolation (batch_size support)
- **Persistent** `/workspace` (models survive restarts)

---

## 📦 What's Included

### Base Template (Vast.ai ComfyUI)
CUDA 13.0, PyTorch, Python 3.12, ComfyUI core, ComfyUI-Manager.

### Custom Nodes (installed by provisioning)
QwenVL-Mod, ComfyUI-MiniMax-H3-Turbo, ComfyUI-sol-attn, ComfyUI-Spectrum-MiniMax-H3, ComfyUI-RIFE-TensorRT-Auto, ComfyUI-Upscaler-TensorRT-Auto, ComfyUI-HuggingFace, comfy-tagcomplete, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, Euler-Smea-Dyn-Sampler, Crystools-MonitorOnly, Civicomfy, Nvidia_RTX_Nodes_ComfyUI.

> MiniMax H3 support is built into ComfyUI 0.30.0. The Turbo LoRA requires the `ComfyUI-MiniMax-H3-Turbo` custom node.

### Workflows (9, downloaded by provisioning)
- `MiniMaxH3-I2VA-Qwen3.5.json`
- `MiniMaxH3-T2VA-Qwen3.5.json`
- `MiniMaxH3-FL2VA-Qwen3.5.json`
- `MiniMaxH3-R2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-I2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-T2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-R2VA-Qwen3.5.json`
- `PMP-LoRaStack-Upscale-Wildcards.json`

### Models auto-downloaded at provisioning (~55 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `vae` | `minimax_h3_video_vae_fp16` | Comfy-Org/MiniMax-H3 | ~5 GB |
| `vae` | `minimax_h3_audio_vae_fp32` | Comfy-Org/MiniMax-H3 | ~0.6 GB |
| `diffusion_models` | `minimax_h3_fl2va_pruned_nvfp4` | lilcheaty/MiniMax-H3-NVFP4 | ~12.5 GB |
| `diffusion_models` | `minimax_h3_ref2va_pruned_nvfp4` | lilcheaty/MiniMax-H3-NVFP4 (R2VA) | ~12.5 GB |
| `text_encoders` | `qwen3vl_32b_h3_ultra_uncensored_heretic_int8_convrot` | ethanfel (uncensored) | ~27 GB |
| `loras` | `minimax_h3_turbo_v4_step600_ema` | larryvrh/MiniMax-H3-Turbo-Lora | ~0.7 GB |

> Models download during provisioning. ComfyUI starts after provisioning completes. No re-download on restart.

---

## 🛠️ Requirements

- **GPU**: RTX 5090+ or Blackwell (NVFP4 requires sm_120+)
- **VRAM**: 32 GB+ recommended (24 GB minimum with offload)
- **Storage**: 120 GB+ SSD
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
2. **Provisioning**: Set `vastai/mmh3-provisioning.sh` as the launch script
3. **First boot**: Provisioning installs nodes, workflows, and downloads models
4. **Load workflow**: `ComfyUI > Load > MiniMaxH3-*-Qwen3.5.json`
5. **Access**: ComfyUI on the assigned port (check Vast.ai instance details)

---

## ⚙️ ComfyUI Args

Add to ComfyUI launch arguments:
```
--fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🎬 Prompting Notes

- Use QwenVL-Mod **MiniMax H3 NSFW (5s/10s/15s)** presets for native video+audio prompts
- Presets produce the official three-field format: `integrated_multimodal_description`, `overall_soundscape`, `non_diegetic_music`
- Audio is generated natively; describe sounds explicitly in the prompt
- Native resolution: **768px short edge**, long edge capped at **1344px**, multiples of 32
- Avoid direct 1080p. Generate at native resolution, then upscale/interpolate with TensorRT nodes
- **Turbo workflows**: 8 steps with Turbo LoRA + SOL-ATTN + Spectrum
- **NVFP4 models** are for Blackwell GPUs only (RTX 5090 / PRO 6000)

---

## 🔄 Persistence

`/workspace/ComfyUI` survives restarts: models, nodes, workflows, outputs. No re-downloads on restart.

---

## 🐳 vs RunPod

| | Vast.ai | RunPod |
|---|---|---|
| **Setup** | Provisioning script | Docker image |
| **ComfyUI path** | `/workspace/ComfyUI` | `/workspace/runpod-slim/ComfyUI` |
| **Pre-baked models** | No (all at provisioning) | Yes (VAE, upscalers) |
| **FileBrowser/Jupyter** | Not included | Included |
| **Cost** | Per-hour, cheaper | Per-hour, fixed |

---

Based on the Vast.ai ComfyUI template with QwenVL-Mod and MiniMax H3 enhancements.
