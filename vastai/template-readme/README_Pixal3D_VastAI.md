# Vast.ai - ComfyUI - Pixal3D / Trellis 2 - Image to 3D Model

Custom ComfyUI on Vast.ai, provisioned with the Pixal3D + Trellis 2 pipeline for generating textured 3D models from a single image.

**Template**: Vast.ai ComfyUI template + `vastai/pixal3d-provisioning.sh`

**Provisioning script**: `vastai/pixal3d-provisioning.sh`

---

## Features

- **Pixal3D + Trellis 2**: Image-to-3D model generation with PBR textures
- **Background removal** via BiRefNet (automatic)
- **MoGe** geometry/FOV estimation for camera-aware conditioning
- **Switchable**: Pixal3D or Trellis 2 mode via boolean toggle
- **Full PBR pipeline**: Base color, metallic, roughness, ambient occlusion, normal maps
- **GLB export**: Ready for game engines, web viewers, 3D printing
- **Persistent** `/workspace` (models survive restarts)

---

## What's Included

### Base Template (Vast.ai ComfyUI)
CUDA, PyTorch, Python, ComfyUI core (v0.33.0+), ComfyUI-Manager.

### Custom Nodes (1, installed by provisioning)
ComfyUI-Manager. All other nodes (Trellis2, Pixal3D, MoGe, BiRefNet, Mesh ops) are built into ComfyUI core v0.33.0+.

### Models auto-downloaded at provisioning (~8 GB, persistent)

| Subfolder | Model | Source | Size |
|---|---|---|---|
| `diffusion_models` | `pixal3d_int8_convrot.safetensors` | Comfy-Org/Pixal3D | ~3.5 GB |
| `diffusion_models` | `trellis_2_int8_convrot.safetensors` | Comfy-Org/TRELLIS.2 | ~3.5 GB |
| `vae` | `trellis_2_texture_vae_bf16.safetensors` | Comfy-Org/Pixal3D | ~250 MB |
| `vae` | `trellis_2_shape_vae_bf16.safetensors` | Comfy-Org/Pixal3D | ~250 MB |
| `clip_vision` | `dino_v3_L_naf_fp32.safetensors` | Comfy-Org/Pixal3D | ~1.2 GB |
| `geometry_estimation` | `moge_2_vitl_normal_fp16.safetensors` | Comfy-Org/MoGe | ~600 MB |
| `background_removal` | `birefnet.safetensors` | Comfy-Org/BiRefNet | ~170 MB |

> Models download during provisioning. ComfyUI starts after provisioning completes. No re-download on restart.

### Workflows (1, downloaded by provisioning)
Pixal3D / Trellis 2 Image-to-3D Model with full PBR texture baking.

### Input Assets
`viking_wolf_rune_axe.png` -- sample image from Comfy-Org workflow templates.

---

## Requirements

- **GPU**: Any CUDA-capable GPU
- **VRAM**: 12GB+ recommended (16GB+ for high-res textures)
- **Storage**: 20GB+ SSD
- **ComfyUI**: v0.33.0+

---

## Environment Variables

Set in Vast.ai template launch options (optional, for gated models):

```
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## Quick Start

1. **Launch**: Select Vast.ai ComfyUI template
2. **Provisioning**: Set `vastai/pixal3d-provisioning.sh` as the launch script
3. **First boot**: Provisioning installs Manager, downloads workflow and all 7 models
4. **Load workflow**: `ComfyUI > Load > pixal3d/3d_pixal3d_trellis2_image_to_model.json`
5. **Upload an image**: Drop your image into the LoadImage node
6. **Run**: Queue the workflow -- generates a textured 3D GLB model

---

## Workflow Details

### Pipeline
1. **Image Pre-Processing**: Background removal (BiRefNet) + crop to mask
2. **Camera FoV Estimation**: MoGe geometry estimation for camera-aware conditioning
3. **Conditioning**: DINO v3 CLIP vision encoding (Pixal3D or Trellis2 mode)
4. **Sparse Structure Generation**: KSampler with RescaleCFG + CFGOverride + ModelSamplingSD3
5. **Shape Generation**: Multi-stage (Shape -> Upsample -> Texture) with dedicated KSamplers
6. **Mesh Post-Processing**: Remesh (UDF) -> Decimate -> Smooth Normals -> Unwrap UV
7. **Texture Baking**: Base color, metallic, roughness, ambient occlusion, normal map
8. **Output**: PBR-textured GLB file with 3D preview and save

### Switching Models
- **Boolean toggle** (`false` = Pixal3D, `true` = Trellis 2)
- Both diffusion models are pre-downloaded

---

## Persistence

`/workspace/ComfyUI` survives restarts: models, workflows, output, user data. No re-downloads on restart.

---

Based on the Vast.ai ComfyUI template with Pixal3D/Trellis 2 3D generation.
