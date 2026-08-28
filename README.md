# ComfyUI-Garage

Il garage di huchukato: workflow e provisioning per ComfyUI su VastAI.

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
│   ├── utils/              Utility WF (LoRa merge, RIFE TensorRT)
│   └── wan22/
│       ├── fp8/            WAN 2.2 in FP8 (7 WF)
│       └── gguf/           WAN 2.2 in GGUF (5 WF)
└── img/                    Banner per README
```

## Link raw dei provisioning

```
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/wan22-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/ltx23-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/ltx25-provisioning.sh
https://github.com/huchukato/ComfyUI-Garage/raw/master/vastai/mmh3-provisioning.sh
```

## Workflow disponibili

### LTX Video (3)
- **23/** — LTX 0.9 I2VA
- **25/** — LTX 2.5 I2VA/T2VA, FL2VA

### MiniMax H3 (8)
- **base/** — FL2VA, I2VA, R2VA, T2VA
- **turbo/** — FL2VA, I2VA, R2VA, T2VA

### WAN 2.2 (12)
- **fp8/** — I2V, T2V, Story, SVI, Full+MMAudio
- **gguf/** — varianti GGUF dei precedenti

### Pony (1)
- PimpMyPony-TagComplete-Wildcards

### Utils (2)
- 2in1-LoRaStack-Merge
- RIFE-TensorRT-60FPS

## Note

- I provisioning script scaricano i WF da questa repo via `raw/main/`.
- Il nodo ComfyUI vero e proprio (`ComfyUI-QwenVL-Mod`) vive in repo separata.
