![ComfyUI UmeAiRT Toolkit](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-umeairt-cu13-r.jpeg)

# OneClick - ComfyUI - UmeAiRT Toolkit - Pony/SDXL Uncensored

Custom ComfyUI based on `huchukato/comfyui-base:cu130`, enhanced with the UmeAiRT Toolkit for block-based generation pipelines, outpainting, ControlNet, FaceDetailer, and UltimateSD Upscale — optimized for Pony/SDXL workflows.

**Template**: `OneClick - ComfyUI - UmeAiRT Toolkit - Pony/SDXL - CU13`

---

## 🚀 Features

- **UmeAiRT Toolkit**: block-based hub-and-spoke pipeline (typed bundles, no noodle soup)
- **Outpainting**: dedicated `Image Process (Outpaint)` node with target dimensions + alignment
- **ControlNet**: Union SDXL + Illustrious/Pony ControlNet (Canny, Depth, OpenPose) with auto-download via aria2
- **FaceDetailer**: built-in face enhancement with BBOX detection
- **UltimateSD Upscale**: tiled upscaling integrated in the pipeline
- **SeedVR2 Upscale**: AI upscaler bundled with the toolkit
- **Hardware Monitor**: real-time CPU/RAM/GPU/VRAM/Temp in the ComfyUI top bar (no Crystocrystals needed)
- **Pony checkpoints**: `pimpmypony_pmpInCaseEnhanced` + `pimpmypony_pmpIncaseStyle` auto-downloaded at boot
- **SDXL VAE** + ESRGAN upscalers pre-baked
- **PimpMyPony workflow** with TagComplete + Wildcards
- **Persistent** `/workspace` (models survive restarts)
- **ComfyUI v0.34.2** baked into base image

---

## 📦 What's Included

### Base Image `huchukato/comfyui-base:cu130`
CUDA 13.0, PyTorch 2.10+cu130, Python 3.12, ComfyUI core, Manager, KJNodes, Civicomfy, RunpodDirect, FileBrowser, Jupyter, SSH.

### Custom Nodes
ComfyUI-UmeAiRT-Toolkit, was-node-suite, ComfyUI-VideoHelperSuite, rgthree-comfy, ComfyUI-Easy-Use, comfyui-find-perfect-resolution, ComfyUI-HuggingFace, comfy-tagcomplete (WildcardProcessor).

### Workflows (2)
Downloaded automatically at boot:

- `PimpMyPony-TagComplete-Wildcards.json`
- `2in1-LoRaStack-Merge.json`

> The UmeAiRT Toolkit nodes appear automatically in ComfyUI under their color-coded categories. Build your own outpaint/inpaint/upscale pipeline using the block architecture.

### Models pre-baked (~1.5 GB)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `vae` | `sdxl.vae.safetensors` | huchukato/favs | ~0.7 GB |
| `upscale_models` | `2xLexicaRRDBNet.pth` | huchukato/favs | ~0.05 GB |
| `upscale_models` | `2xLexicaRRDBNet_Sharp.pth` | huchukato/favs | ~0.05 GB |

### Models auto-downloaded at first boot (~13 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `checkpoints` | `pimpmypony_pmpInCaseEnhanced.safetensors` | huchukato/favs | ~6.5 GB |
| `checkpoints` | `pimpmypony_pmpIncaseStyle.safetensors` | huchukato/favs | ~6.5 GB |

### ControlNet (auto-downloaded by UmeAiRT Toolkit on first use)

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
3. **Load workflow**: `ComfyUI > Load > PimpMyPony-TagComplete-Wildcards.json`
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

The toolkit uses a hub-and-spoke pipeline with typed bundles:

1. **Model Loader** → `UME_BUNDLE` (model + clip + vae)
2. **Generation Settings** → `UME_SETTINGS` (width, height, steps, cfg, seed)
3. **Positive/Negative Prompt** → multiline editors
4. **LoRA 1x/3x/5x/10x** → stackable LoRA loaders
5. **Image Process** → choose mode: img2img / inpaint / outpaint
6. **KSampler** → central hub, receives all bundles → `UME_PIPELINE`
7. **Post-processing** → UltimateSD Upscale / SeedVR2 / FaceDetailer / Image Saver

### Outpainting

1. Load a Pony checkpoint via `Model Loader`
2. Set target dimensions in `Generation Settings`
3. Connect image to `Image Process (Outpaint)` — set alignment + target size
4. Connect to `KSampler` — outpaint executes automatically
5. Chain `UltimateSD Upscale` for higher resolution

### Interoperability

Use `Pack Models Bundle` to wrap any native/community loader into `UME_BUNDLE`, and `Unpack Pipeline` to extract IMAGE + all 14 fields for native nodes. Full compatibility with existing ComfyUI workflows.

---

## 🔄 Persistence

`/workspace/runpod-slim/ComfyUI` survives restarts: models, nodes, workflows, outputs.

---

Based on RunPod template with UmeAiRT Toolkit and Pony/SDXL enhancements.
