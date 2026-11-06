![ComfyUI-QwenVL-Mod LTX 2.5 + Qwen 2.1](https://raw.githubusercontent.com/huchukato/ComfyUI-Garage/master/img/b-ltx25-qwen21-cu132-v.jpeg)

# Vast.ai - ComfyUI - LTX 2.5 Uncensored + Qwen 2.1 Image Edit - Qwen3.5

Custom ComfyUI on Vast.ai, provisioned with QwenVL-Mod: native LTX 2.5 video+audio generation, Qwen Image 2.1 text-to-image and image editing, and LTX-Director for long multi-segment videos built from generated keyframe stills.

**Template**: Vast.ai ComfyUI template + `vastai/ltx25-qwen21-provisioning.sh`

**Provisioning script**: `vastai/ltx25-qwen21-provisioning.sh`

---

## 🚀 Features

- **LTX 2.5 native video+audio**: T2VA, I2VA, FL2VA, Loop — synchronized audio generation
- **LTX-Director**: keyframe timeline + prompt relay for ~1-minute multi-scene videos (keyframes generated with Qwen 2.1 or uploaded)
- **Qwen Image 2.1**: T2I and multi-reference edit with wildcard prompts — the still generator for Director keyframes
- **Qwen3-VL auto-prompting**: multilingual prompts, per-mode presets (incl. new LTX SFW I2V/T2V)
- **Uncensored text encoders**: DeepNeuralNerd Gemma 4 12B (LTX), Qwen3-VL-8B Heretic (Qwen)
- **GGUF enhancer** via llama-cpp-python CUDA 13
- **Sage Attention**, FP16 accumulation, TensorRT upscale/interp
- **Persistent** `/workspace` — models survive restarts

---

## 📦 What's Included

### Workflows (downloaded by provisioning)
- `ltx/LTX25-I2VA-T2VA-Qwen3.5.json`, `ltx/LTX25-FL2VA-Qwen3.5.json`, `ltx/LTX25-Loop-ABCBA-Qwen3.5.json`
- `qwen21/QwenImage21-T2I-Wildcards-Qwen3.5.json`, `qwen21/QwenImageEdit21-Wildcards-Qwen3.5.json`
- `utils/`: RIFE-Upscale-TensorRT, LoRaStack-Merge, Pony-XL-Outpaint

### Models (~80 GB — use ≥120 GB disk)
- **LTX 2.5**: 22B distilled DiT int8, Gemma-4-12B-heretic encoder, video+audio VAE, spatial+temporal latent upscalers, 10Eros LoRA
- **Qwen 2.1**: int8 ConvRot DiT, Qwen3-VL-8B Heretic encoder, VAE, detailer LoRA
- **LLM**: Qwen3.5-9B Defiant-Fable NEO-MAX Q6_K + mmproj (QwenVL enhancer)

---

## 🔑 Environment Variables

```
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🚀 Quick Start

1. **Launch**: Vast.ai ComfyUI template (CUDA 13.0)
2. **Provisioning**: paste `vastai/ltx25-qwen21-provisioning.sh` as the launch script
3. **First boot**: nodes + workflows + ~80 GB models download (≈45-60 min)
4. **ComfyUI args**: `--use-sage-attention --enable-manager` (add manually in the template extra args)
5. **Load workflow**: `ComfyUI > Load` → pick the `ltx/` or `qwen21/` folder

---

## 🎬 Prompting Notes

- QwenVL output goes **directly** to CLIPTextEncode — the native enhancer stays bypassed
- LTX 2.5 generates **synchronized audio**: put dialogue in quotes, name language/accent, describe ambient sounds
- LTX uses `UNETLoader` + `VAELoader` (separate files)
- **Director flow**: generate keyframe stills in the Qwen 2.1 T2I workflow → load them into LTX Keyframer → set per-segment prompts → LTX Director + Sequencer render the long video

---

## ⚠️ Notes

- QwenVL-Mod syncs presets from the Garage repo at boot — latest presets arrive without re-provisioning
- Everything lands on `/workspace` — deleting the instance loses nothing if you keep the volume
