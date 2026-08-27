![ComfyUI-QwenVL-Mod LTX 2.3](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-ltx23-cu13-v.jpg)

# Vast.ai - ComfyUI - LTX 2.3 Uncensored - Qwen3.5

Custom ComfyUI on Vast.ai, provisioned with QwenVL-Mod and native LTX 2.3 video+audio generation with Qwen3-VL auto-prompting. Uncensored 10Eros setup for NSFW I2V.

**Template**: Vast.ai ComfyUI template + `vastai/ltx23-provisioning.sh`

**Provisioning script**: `vastai/ltx23-provisioning.sh`

---

## 🚀 Features

- **LTX 2.3 native video+audio**: I2V with synchronized audio generation
- **10Eros v1.5 uncensored**: merge of Sulphur 2 optimized for NSFW I2V
- **Gemma 3 12B abliterated**: natively uncensored text encoder (norms + bi-projection baked in, FP8)
- **Multilingual prompts** with visual style detection via QwenVL-Mod
- **Direct QwenVL → CLIPTextEncode**: LTX prompt enhancer bypassed (preserves prompt intent)
- **GGUF backend** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, async offload
- **TensorRT** upscaling and frame interpolation
- **Spatial + temporal upscalers** included
- **Persistent** `/workspace` (models survive restarts)
- **hf-transfer** for fast multi-connection downloads

---

## 📦 What's Included

### Base Template (Vast.ai ComfyUI)
CUDA 13.0, PyTorch, Python 3.12, ComfyUI core, ComfyUI-Manager.

### Custom Nodes (installed by provisioning)
QwenVL-Mod, ComfyUI-LTXVideo (Lightricks), ComfyUI-RIFE-TensorRT-Auto, ComfyUI-Upscaler-TensorRT-Auto, ComfyUI-HuggingFace, comfy-tagcomplete, Euler-Smea-Dyn-Sampler, was-node-suite, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, Civicomfy, ComfyUI-Crystools-MonitorOnly.

> LTX 2.3 core nodes are built into ComfyUI 0.30.0+. `ComfyUI-LTXVideo` adds workflow-specific nodes.

### Workflows (3, downloaded by provisioning)
- `LTX23-I2VA-Qwen3.5.json` — I2V+Audio with QwenVL auto-prompt, 10Eros, dual-stage with spatial upscaler
- `LTX23-FL2VA-Qwen3.5.json` — First+Last frame to video with audio
- `PMP-LoRaStack-Upscale-Wildcards.json` — Shared Pony/LoRA stack + upscale + wildcards workflow

### Models auto-downloaded at provisioning (~45 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `checkpoints` | `10Eros_v1.5_fp8mixed_experimental_learned.safetensors` | LokkenJP/10EROS_1.5_fp8_exp_learned (uncensored) | ~30 GB |
| `text_encoders` | `gemma-3-12b-it-ablit-norms-biproj-fp8mixed.safetensors` | TenStrip/LTX2.3-10Eros (natively abliterated, FP8, bi-projection baked in) | ~12.8 GB |
| `loras/ltx23` | `LTX2.3_DMD_hybrid_v2.safetensors` | TenStrip/LTX2.3_DMD_Lora (DMD hybrid for 10Eros v1.5) | ~662 MB |
| `loras` | `gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors` | Comfy-Org/ltx-2 (prompt enhancer LoRA) | ~662 MB |
| `latent_upscale_models` | `ltx-2.3-spatial-upscaler-x2-1.1` | Lightricks/LTX-2.3 (2x resolution) | ~996 MB |
| `latent_upscale_models` | `ltx-2.3-temporal-upscaler-x2-1.0` | Lightricks/LTX-2.3 (2x frames) | ~262 MB |
| `vae` | `pruna_ltx2.3_vae_comfy_bf16.safetensors` | Kijai/LTX2.3_comfy (optimized decode) | ~500 MB |

> Models download during provisioning. ComfyUI starts after provisioning completes. No re-download on restart.

---

## 🛠️ Requirements

- **GPU**: RTX 5090+ or any CUDA 13.0 card
- **VRAM**: 24 GB+ recommended
- **Storage**: 100 GB+ SSD
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
2. **Provisioning**: Set `vastai/ltx23-provisioning.sh` as the launch script
3. **First boot**: Provisioning installs nodes, workflows, and downloads models
4. **Load workflow**: `ComfyUI > Load > LTX23-I2VA-Qwen3.5.json`
5. **Access**: ComfyUI on the assigned port (check Vast.ai instance details)

---

## ⚙️ ComfyUI Args

Add to ComfyUI launch arguments:
```
--fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🎬 Prompting Notes

- Use QwenVL-Mod **🎥 LTX 2.3 NSFW I2V** preset (mandatory audio instructions)
- QwenVL output goes **directly** to CLIPTextEncode — LTX enhancer bypassed
- LTX 2.3 generates **synchronized audio**: always specify dialogue (in quotes), tone of voice, and ambient sounds
- Frame count must be N×8+1 (121 = ~5s, 201 = ~8.4s). Use temporal upscaler for longer videos
- Native resolution ~768px short edge. Use spatial upscaler for higher resolution
- Do NOT use `distilled-lora-384` or `condsafe` with 10Eros v1.5 — use the `DMD hybrid v2` LoRA only

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

Based on the Vast.ai ComfyUI template with QwenVL-Mod and LTX 2.3 enhancements.
