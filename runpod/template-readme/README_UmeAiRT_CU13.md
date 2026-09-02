![ComfyUI UmeAiRT Toolkit](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-umeairt-cu13-r.jpeg)

# OneClick - ComfyUI - UmeAiRT Toolkit - Pony/SDXL Uncensored

Custom ComfyUI based on `huchukato/comfyui-base:cu130`, enhanced with the UmeAiRT Toolkit for block-based generation pipelines, outpainting, ControlNet, FaceDetailer, and UltimateSD Upscale — optimized for Pony/SDXL workflows.

**Template**: `OneClick - ComfyUI - UmeAiRT Toolkit - Pony/SDXL - CU13`

---

## 🚀 Features

- **UmeAiRT Toolkit**: block-based hub-and-spoke pipeline (typed bundles, no noodle soup)
- **Outpainting**: `Image Process (Outpaint)` with target dimensions + alignment
- **ControlNet**: Union SDXL + Illustrious/Pony (Canny, Depth, OpenPose) with auto-download via aria2
- **FaceDetailer**: built-in face enhancement with BBOX detection
- **UltimateSD Upscale**: tiled upscaling integrated in the pipeline
- **SeedVR2 Upscale**: AI upscaler bundled
- **Hardware Monitor**: real-time CPU/RAM/GPU/VRAM/Temp in the top bar
- **Pony checkpoints**: `pmpInCaseEnhanced` + `pmpIncaseStyle` auto-downloaded at boot
- **SDXL VAE** + ESRGAN upscalers pre-baked (2xLexica, 2xLexica Sharp, RealESRGAN_x2plus)
- **PimpMyPony workflow** with TagComplete + Wildcards
- **9 UmeAiRT example workflows** (SDXL Outpaint, Inpaint, Img2Img, Txt2Img, LoRA Tester, ControlNet, UltimateSD Upscale, Z-IMG, AllToolkitNodes)
- **Persistent** `/workspace` (models survive restarts)
- **ComfyUI v0.34.2** baked into base image

---

## 📦 What's Included

### Base Image `huchukato/comfyui-base:cu130`
CUDA 13.0, PyTorch 2.10+cu130, Python 3.12, ComfyUI core, Manager, KJNodes, Civicomfy, RunpodDirect, FileBrowser, Jupyter, SSH.

### Custom Nodes
ComfyUI-UmeAiRT-Toolkit, was-node-suite, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, ComfyUI-HuggingFace, comfy-tagcomplete.

### Workflows (11)
Downloaded automatically at boot:

- `pony/PimpMyPony-TagComplete-Wildcards.json`
- `utils/2in1-LoRaStack-Merge.json`
- `umeairt/SDXL_Outpaint.json`
- `umeairt/SDXL_Inpaint.json`
- `umeairt/SDXL_Img2Img.json`
- `umeairt/SDXL_Txt2Img.json`
- `umeairt/SDXL_LoraTester.json`
- `umeairt/SDXL_ControlNet.json`
- `umeairt/SDXL_UltimateSD-Upscale.json`
- `umeairt/Z-IMG_ALL2IMG.json`
- `umeairt/AllToolkitNodes.json`

### Models pre-baked (~1.7 GB)

| Subfolder | Model | Size |
|---|---|---|
| `vae` | `sdxl.vae.safetensors` | ~0.7 GB |
| `upscale_models` | `2xLexicaRRDBNet.pth` | ~0.05 GB |
| `upscale_models` | `2xLexicaRRDBNet_Sharp.pth` | ~0.05 GB |
| `upscale_models` | `RealESRGAN_x2plus.pth` | ~0.06 GB |

### Models auto-downloaded at first boot (~13 GB, persistent)

| Subfolder | Model | Size |
|---|---|---|
| `checkpoints` | `pimpmypony_pmpInCaseEnhanced.safetensors` | ~6.5 GB |
| `checkpoints` | `pimpmypony_pmpIncaseStyle.safetensors` | ~6.5 GB |

### ControlNet (auto-downloaded by toolkit on first use)
The toolkit auto-downloads ControlNet models from its CDN via aria2 when you select them in the Block Sampler. No manual setup needed.

> ComfyUI starts immediately; models download in background. No re-download on restart.

---

## 🛠️ Requirements

- **GPU**: RTX 5090+ or any Blackwell GPU (sm_120+)
- **VRAM**: 24 GB+ recommended (16 GB with offload)
- **Storage**: 40 GB+ SSD

---

## 🔑 Hugging Face Token (optional)

```
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🚀 Quick Start

1. **Deploy**: Select `OneClick - ComfyUI - UmeAiRT Toolkit - Pony/SDXL - CU13`
2. **First boot**: ComfyUI copies to `/workspace`, Pony checkpoints download in background
3. **Load workflow**: `ComfyUI > Load > umeairt/SDXL_Outpaint.json` (or any other example)
4. **Or build your own**: use UmeAiRT block nodes (Model Loader → Generation Settings → Image Process → KSampler → UltimateSD Upscale)
5. **Access**: ComfyUI `:8188` · JupyterLab `:8888` · FileBrowser `:8080` · SSH `ssh root@pod-ip`

> **FileBrowser**: user `admin` · pass `adminadmin12`

---

## ⚙️ ComfyUI Args

```
--disable-auto-launch --fast fp16_accumulation --use-sage-attention --cuda-malloc --async-offload
```

---

## 🎨 UmeAiRT Block Architecture

1. **Model Loader** → `UME_BUNDLE`
2. **Generation Settings** → `UME_SETTINGS`
3. **Prompts** + **LoRA stack** → feed into KSampler
4. **Image Process** → img2img / inpaint / outpaint
5. **KSampler** → `UME_PIPELINE`
6. **Post-processing** → UltimateSD Upscale / SeedVR2 / FaceDetailer

Use `Pack/Unpack` nodes for full compatibility with existing ComfyUI workflows.

---

## 🔄 Persistence

`/workspace/runpod-slim/ComfyUI` survives restarts: models, nodes, workflows, outputs.

---

Based on RunPod template with UmeAiRT Toolkit and Pony/SDXL enhancements.
