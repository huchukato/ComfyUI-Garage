![ComfyUI-QwenVL-Mod LTX 2.5](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-ltx25-cu13-v.jpg)

# Vast.ai - ComfyUI - LTX 2.5 Uncensored - Qwen3.5

Custom ComfyUI on Vast.ai, provisioned with QwenVL-Mod and native LTX 2.5 video+audio generation with Qwen3-VL auto-prompting. Uncensored DeepNeuralNerd Gemma 4 setup for NSFW I2V.

**Template**: Vast.ai ComfyUI template + `vastai/ltx25-provisioning.sh`

**Provisioning script**: `vastai/ltx25-provisioning.sh`

---

## 🚀 Features

- **LTX 2.5 native video+audio**: I2V with synchronized audio generation
- **22B distilled transformer**: INT8 ConvRot (Lightricks)
- **DeepNeuralNerd uncensored Gemma 4 12B**: text encoder preserving LTX 2.5 projections (INT8 ConvRot)
- **Gemma 4 E2B uncensored**: prompt enhancer (TrevorJS)
- **Multilingual prompts** with visual style detection via QwenVL-Mod
- **Direct QwenVL → CLIPTextEncode**: LTX prompt enhancer bypassed (preserves prompt intent)
- **GGUF backend** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, async offload
- **TensorRT** upscaling and frame interpolation
- **Spatial upscaler** included (I2VA)
- **Persistent** `/workspace` (models survive restarts)
- **hf-transfer** for fast multi-connection downloads

---

## 📦 What's Included

### Base Template (Vast.ai ComfyUI)
CUDA 13.0, PyTorch, Python 3.12, ComfyUI core, ComfyUI-Manager.

### Custom Nodes (installed by provisioning)
QwenVL-Mod, ComfyUI-LTXVideo (Lightricks), ComfyUI-RIFE-TensorRT-Auto, ComfyUI-Upscaler-TensorRT-Auto, ComfyUI-HuggingFace, comfy-tagcomplete, Euler-Smea-Dyn-Sampler, was-node-suite, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, Civicomfy, ComfyUI-Crystools-MonitorOnly.

> LTX 2.5 core nodes are built into ComfyUI 0.30.0+. `ComfyUI-LTXVideo` adds workflow-specific nodes.

### Workflows (2, downloaded by provisioning)
- `LTX25-I2VA-Qwen3.5.json` — I2V+Audio with QwenVL auto-prompt, DeepNeuralNerd encoder, Gemma 4 E2B prompt enhancer, dual-stage with latent spatial upscaler
- `LTX25-FL2VA-Qwen3.5.json` — First+Last frame to video with audio

### Models auto-downloaded at provisioning (~48 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `diffusion_models` | `ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors` | huchukato/pimp-my-wan (mirror of Lightricks/LTX-2.5) | ~21 GB |
| `text_encoders` | `gemma4-12b-uncensored-heretic-ltx2.5-comfy-int8-convrot.safetensors` | DeepNeuralNerd (uncensored heretic, INT8 ConvRot) | ~13.2 GB |
| `text_encoders` | `gemma4_e2b_it_bf16.safetensors` | TrevorJS/gemma-4-E2B-it-uncensored (prompt enhancer, I2VA only) | ~10 GB |
| `vae` | `ltx-2.5-video-vae-bf16.safetensors` | huchukato/pimp-my-wan | ~1.4 GB |
| `vae` | `ltx-2.5-audio-vae-bf16.safetensors` | huchukato/pimp-my-wan | ~350 MB |
| `latent_upscale_models` | `ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors` | huchukato/pimp-my-wan (2x resolution, I2VA only) | ~990 MB |
| `latent_upscale_models` | `ltx-2.5-latent-temporal-upscaler-x2-bf16-1.0.safetensors` | huchukato/pimp-my-wan (2x frames) | ~250 MB |
| `model_patches` | `ltx-2.5-duration-head-bf16.safetensors` | huchukato/pimp-my-wan | ~4 MB |

> Models download during provisioning. ComfyUI starts after provisioning completes. No re-download on restart.

---

## 🛠️ Requirements

- **GPU**: RTX 5090+ or any CUDA 13.0 card
- **VRAM**: 24 GB+ recommended
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
2. **Provisioning**: Set `vastai/ltx25-provisioning.sh` as the launch script
3. **First boot**: Provisioning installs nodes, workflows, and downloads models
4. **Load workflow**: `ComfyUI > Load > LTX25-I2VA-Qwen3.5.json`
5. **Access**: ComfyUI on the assigned port (check Vast.ai instance details)

---

## ⚙️ ComfyUI Args

Add to ComfyUI launch arguments:
```
--fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🎬 Prompting Notes

- Use QwenVL-Mod LTX 2.5 NSFW presets (mandatory audio instructions)
- QwenVL output goes **directly** to CLIPTextEncode — LTX enhancer bypassed
- LTX 2.5 generates **synchronized audio**: put dialogue in quotes, name language/accent, describe tone and ambient sounds
- Use temporal upscaler for longer videos, spatial upscaler for higher resolution
- LTX 2.5 uses `UNETLoader` + `VAELoader` (transformer and VAE are separate files, unlike LTX 2.3)

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

Based on the Vast.ai ComfyUI template with QwenVL-Mod and LTX 2.5 enhancements.
