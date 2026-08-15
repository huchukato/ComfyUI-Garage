# ComfyUI-Garage

Il garage di huchukato: workflow e provisioning per ComfyUI su VastAI, Docker per RunPod.

## Struttura

```
ComfyUI-Garage/
├── vastai/                 Provisioning script (pubblici, scaricabili via raw)
│   ├── wan22-provisioning.sh
│   ├── ltx23-provisioning.sh
│   ├── ltx25-provisioning.sh
│   └── mmh3-provisioning.sh
├── workflows/              Workflow JSON pronti da caricare in ComfyUI
│   ├── ltx/
│   │   ├── 23/             LTX Video 0.9 (1 WF)
│   │   └── 25/             LTX Video 2.5 (2 WF)
│   ├── minimax/
│   │   ├── base/           MiniMax H3 base (4 WF)
│   │   └── turbo/          MiniMax H3 Turbo (4 WF)
│   ├── pony/               Pony Diffusion (1 WF)
│   └── wan22/
│       ├── fp8/            WAN 2.2 in FP8 (7 WF)
│       └── gguf/           WAN 2.2 in GGUF (5 WF)
├── runpod/                 Docker RunPod (locale, gitignored)
│   ├── Dockerfile.CU13-WAN22
│   ├── Dockerfile.CU128-WAN22
│   ├── Dockerfile.CU13-LTX23
│   ├── Dockerfile.CU13-LTX25
│   ├── Dockerfile.CU13-MMH3
│   ├── docker-compose.yml
│   ├── img/                Banner per README
│   └── template-readme/    README template per ogni immagine
├── buildscript/            Script di build Docker (locale, gitignored)
│   ├── build-and-push-CU13-WAN22.sh
│   ├── build-and-push-CU128-WAN22.sh
│   ├── build-and-push-CU13-LTX23.sh
│   ├── build-and-push-CU13-LTX25.sh
│   ├── build-and-push-CU13-MMH3.sh
│   └── build-and-push-VastAI.sh
└── trashcan/               Roba deprecata (locale, gitignored)
```

## Cosa è pubblico e cosa è locale

| Cartella | Git | Note |
|----------|-----|------|
| `vastai/` | Si | Provisioning script scaricabili via `raw/main/` |
| `workflows/` | Si | WF JSON scaricabili via `raw/main/` |
| `runpod/` | No | Dockerfile e config locali (gitignored) |
| `buildscript/` | No | Script di build locali (gitignored) |
| `trashcan/` | No | Da svuotare prima del push |

## Link raw dei provisioning

```
https://github.com/huchukato/ComfyUI-Garage/raw/main/vastai/wan22-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/main/vastai/ltx23-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/main/vastai/ltx25-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/main/vastai/mmh3-provisioning.sh
```

## Workflow disponibili (24 totali)

### LTX Video (3)
- **23/** — LTX 0.9 I2VA
- **25/** — LTX 2.5 I2VA, FL2VA

### MiniMax H3 (8)
- **base/** — FL2VA, I2VA, R2VA, T2VA
- **turbo/** — FL2VA, I2VA, R2VA, T2VA

### WAN 2.2 (12)
- **fp8/** — I2V, T2V, Story, SVI, Full+MMAudio
- **gguf/** — varianti GGUF dei precedenti

### Pony (1)
- PMP-LoRaStack-Upscale-Wildcards

## Immagini Docker RunPod

| Dockerfile | Base | Target |
|------------|------|--------|
| `CU13-WAN22` | runpod/comfyui:cuda13.0 | WAN 2.2 su CUDA 13 |
| `CU128-WAN22` | runpod/comfyui:cuda12.8 | WAN 2.2 su CUDA 12.8 (4090/5090) |
| `CU13-LTX23` | runpod/comfyui:cuda13.0 | LTX 0.9 |
| `CU13-LTX25` | runpod/comfyui:cuda13.0 | LTX 2.5 |
| `CU13-MMH3` | runpod/comfyui:cuda13.0 | MiniMax H3 |

## Note

- I provisioning script scaricano i WF da questa repo via `raw/main/`.
- I Dockerfile sono in `.gitignore` perché contengono path e config locali.
- Il nodo ComfyUI vero e proprio (`ComfyUI-QwenVL-Mod`) vive in repo separata.
