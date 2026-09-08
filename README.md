# ComfyUI-Garage

Workflow, provisioning e Docker image per ComfyUI su VastAI e RunPod.

---

## OneClick Templates

### Vast.ai

| Template | Link |
|---|---|
| WAN 2.2 Uncensored - Qwen3.5 AutoPrompt | [Deploy on Vast.ai](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20Wan%202.2%20Uncensored%20-%20Qwen3.5%20AutoPrompt) |
| Pixal3D / Trellis 2 | [Deploy on Vast.ai](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20Pixal3D%20%2F%20Trellis%202) |
| MiniMax H3 Turbo Uncensored - Qwen3.5 | [Deploy on Vast.ai](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20MiniMax%20H3%20Turbo%20Uncensored%20-%20Qwen3.5%20AutoPrompt) |
| LTX 2.5 Uncensored - Qwen3.5 | [Deploy on Vast.ai](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20LTX%202.5%20Uncensored%20-%20Qwen3.5%20AutoPrompt) |
| LTX 2.3 Uncensored - Qwen3.5 | [Deploy on Vast.ai](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20LTX%202.3%20Uncensored%20-%20Qwen3.5%20AutoPrompt) |

### RunPod

| Template | Link |
|---|---|
| WAN 2.2 - CUDA 13 (Blackwell) | [Deploy on RunPod](https://console.runpod.io/hub/template/1v8gfux2zd?ref=ioakclrv) |
| WAN 2.2 - CUDA 12.8 (Ada) | [Deploy on RunPod](https://console.runpod.io/hub/template/nis3j4utig?ref=ioakclrv) |
| MiniMax H3 Turbo | [Deploy on RunPod](https://console.runpod.io/hub/template/bii5d425kp?ref=ioakclrv) |
| LTX 2.5 | [Deploy on RunPod](https://console.runpod.io/hub/template/mixtytd9um?ref=ioakclrv) |
| LTX 2.3 | [Deploy on RunPod](https://console.runpod.io/hub/template/06xkj4x3dt?ref=ioakclrv) |
| UmeAiRT Toolkit - Pony/SDXL | [Deploy on RunPod](https://console.runpod.io/hub/template/c6sucxx0tu?ref=ioakclrv) |

---

## Struttura

```
ComfyUI-Garage/
├── vastai/                 Provisioning script per Vast.ai
│   ├── wan22-provisioning.sh
│   ├── pixal3d-provisioning.sh
│   ├── ltx23-provisioning.sh
│   ├── ltx25-provisioning.sh
│   └── mmh3-provisioning.sh
├── workflows/              Workflow JSON pronti da caricare in ComfyUI
│   ├── wan22/              WAN 2.2 (8 WF)
│   ├── pixal3d/            Pixal3D / Trellis 2 (1 WF)
│   ├── minimax/            MiniMax H3 Turbo (5 WF)
│   ├── ltx/
│   │   ├── 23/             LTX 2.3 (2 WF)
│   │   └── 25/             LTX 2.5 (2 WF)
│   ├── pony/               PimpMyPony (3 WF)
│   ├── umeairt/            UmeAiRT Toolkit SDXL (9 WF)
│   ├── t2i/                Text-to-Image (2 WF)
│   └── utils/              Utility (2 WF)
└── img/                    Banner per README
```

## Link raw dei provisioning (Vast.ai)

```
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/wan22-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/pixal3d-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/ltx23-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/ltx25-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/mmh3-provisioning.sh
```

## Workflow disponibili

### WAN 2.2 (8)
T2V, I2V, I2V-20s, FL2V, SVI-20s, Story I2V/SVI/T2V-I2V — tutti con Qwen3.5 AutoPrompt

### Pixal3D / Trellis 2 (1)
Image-to-3D Model con PBR textures (base color, metallic, roughness, AO, normal)

### MiniMax H3 Turbo (5)
FL2VA, FL2VA-Loop, I2VA, R2VA, T2VA — tutti con Qwen3.5 AutoPrompt

### LTX Video (4)
- **2.3/** — FL2VA, I2VA-T2VA
- **2.5/** — FL2VA, I2VA-T2VA

### Pony (3)
PimpMyPony TagComplete + Wildcards, HiresFix, FaceDet

### UmeAiRT Toolkit (9)
AllToolkitNodes, ControlNet, Img2Img, Inpaint, LoraTester, Outpaint, Txt2Img, UltimateSD-Upscale, ALL2IMG

### T2I (2)
FluxDev1-T2I, ZImageTurbo-T2I

### Utils (2)
2in1-LoRaStack-Merge, RIFE-TensorRT-60FPS

---

## Note

- I provisioning script VastAI scaricano i WF da questa repo via `raw/master/`.
- I Docker RunPod sono pre-baked con nodi e modelli essenziali, i modelli pesanti si scaricano al primo boot.
- Il nodo `ComfyUI-QwenVL-Mod` vive in [repo separata](https://github.com/huchukato/ComfyUI-QwenVL-Mod).
