![ComfyUI-QwenVL-Mod MiniMax H3](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-mmh3-cu13-r.jpg)

# OneClick - ComfyUI - MiniMax H3 Turbo Uncensored

Custom ComfyUI based on `runpod/comfyui:cuda13.0`, enhanced with QwenVL-Mod and native MiniMax H3 video+audio generation with Qwen3-VL auto-prompting.

**Template**: `OneClick - ComfyUI - MiniMax H3 Uncensored - CU13`

---

## 🚀 Features

- **MiniMax H3 native video+audio**: T2VA, I2VA, FL2VA / R2VA workflows
- **NVFP4 quantization** text encoder for Blackwell GPUs (RTX 5090 / PRO 6000)
- **SOL-ATTN** (Scheduled Sol Attention) for sharper Turbo output
- **Spectrum** adaptive smoothing for Turbo workflows
- **Built-in audio generation**: no separate MMAudio node required
- **Multilingual prompts** with visual style detection via QwenVL-Mod
- **GGUF backend** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, async offload
- **TensorRT**: verified Upscaler batch `2/2`; RIFE v4.25 at batch `1/1`
- **Auto-detect upscale factor**: scale (2x/4x) derived from model name, no manual dropdown
- **Persistent** `/workspace` (models survive restarts)
- **ComfyUI v0.33.1+** forced at boot (MiniMax H3 requirement)

---

## 📦 What's Included

### Base Image (`runpod/comfyui:cuda13.0`)
CUDA 13.0, PyTorch 2.10+cu130, Python 3.12, ComfyUI core, Manager, KJNodes, Civicomfy, RunpodDirect, FileBrowser, Jupyter, SSH.

### Custom Nodes
QwenVL-Mod, ComfyUI-MiniMax-H3-Turbo, ComfyUI-sol-attn, ComfyUI-Spectrum-MiniMax-H3, ComfyUI-RIFE-TensorRT-Auto, ComfyUI-Upscaler-TensorRT-Auto, ComfyUI-HuggingFace, comfy-tagcomplete, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, Euler-Smea-Dyn-Sampler, Civicomfy.

### Workflows (4)
Downloaded automatically at boot:

- `MiniMaxH3-Turbo-I2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-T2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json`
- `MiniMaxH3-Turbo-R2VA-Qwen3.5.json`

### Models auto-downloaded at first boot (~87 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `vae` | `minimax_h3_video_vae_fp16` | Comfy-Org/MiniMax-H3 | ~5 GB |
| `vae` | `minimax_h3_audio_vae_fp32` | Comfy-Org/MiniMax-H3 | ~0.6 GB |
| `diffusion_models` | `minimax_h3_fl2va_pruned_nvfp4_convrot_int8` | lilcheaty/MiniMax-H3-NVFP4 (Blackwell) | ~20 GB |
| `diffusion_models` | `minimax_h3_ref2va_pruned_nvfp4_convrot_int8` | lilcheaty/MiniMax-H3-NVFP4 (R2VA, Blackwell) | ~20 GB |
| `text_encoders` | `qwen3vl_32b_heretic_minimax_h3_nvfp4` | Momoking (uncensored, Blackwell) | ~15.7 GB |
| `loras` | `minimax_h3_turbo_v4_step600_ema` | larryvrh/MiniMax-H3-Turbo-Lora | ~0.7 GB |
| `diffusion_models` | `10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ` | DmitryDB (optional/experimental) | ~23.5 GB |
| `loras` | `minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8` | t8star (10Eros only) | ~1.96 GB |

> ComfyUI starts immediately; models download in background. No re-download on restart.

---

## 🛠️ Requirements

- **GPU**: RTX 5090+ or Blackwell (NVFP4 text encoder needs sm_120+; INT8 diffusion works on any GPU)
- **VRAM**: 32 GB+ recommended (24 GB minimum with offload)
- **Storage**: 120 GB+ SSD

---

## 🔑 Hugging Face Token (optional but recommended)

```
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🚀 Quick Start

1. **Deploy**: Select `OneClick - ComfyUI - MiniMax H3 Uncensored - CU13`
2. **First boot**: ComfyUI copies to `/workspace`, models download in background
3. **Load workflow**: `ComfyUI > Load > MiniMaxH3-*-Qwen3.5.json`
4. **Access**: ComfyUI `:8188` · JupyterLab `:8888` · FileBrowser `:8080` · SSH `ssh root@pod-ip`

> **FileBrowser credentials**: user `admin` · password `adminadmin12`

---

## ⚙️ ComfyUI Args

```
--disable-auto-launch --fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🎬 Prompting Notes

- Use QwenVL-Mod **MiniMax H3 NSFW (5s/10s/15s)** presets for native video+audio prompts
- Audio is generated natively; describe sounds explicitly in the prompt
- Native resolution: **768px short edge**, long edge capped at **1344px**, multiples of 32
- Avoid direct 1080p. Generate at native resolution, then upscale/interpolate with TensorRT nodes
- **Turbo workflows**: 8 steps with `minimax_h3_turbo_v4_step600_ema` LoRA + SOL-ATTN + Spectrum
- **NVFP4+INT8 ConvRot hybrid** (rockerBOO/lilcheaty) — default, best speed/quality on Blackwell. NVFP4 on MLP, INT8 ConvRot on attention
- **RIFE v4.25** — recommended for diffusion video. ONNX from HF, TRT engine built at first use
- **10Eros-Max**: optional INT8 ConvRot HQ. NVFP4 degrades it. Switch model + LoRA together
- Keep RIFE v4.25 loader/runner at `1/1`; use Upscaler loader/runner at the verified `2/2`

---

## 🔄 Persistence

`/workspace/runpod-slim/ComfyUI` survives restarts: models, nodes, workflows, outputs.

---

Based on RunPod template with QwenVL-Mod and MiniMax H3 enhancements.
