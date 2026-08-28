# [MiniMax H3] NSFW T2VA/I2VA/FL2VA/R2VA Workflows 🎬 Auto Prompt | Native Audio | TensorRT Upscale | RIFE Interpolation

![MiniMax H3 Qwen3VL](https://raw.githubusercontent.com/huchukato/ComfyUI-QwenVL-Mod/main/img/bannerminimax.png)

ComfyUI-QwenVL-Mod — Enhanced Vision-Language with MiniMax H3
Version 2.6.0 (2026/08/27) — 🎬 MiniMax H3 Native Video+Audio + NVFP4 Blackwell + SOL-ATTN + Spectrum + Turbo LoRA

---

## ⬆️ 2026/08/27 UPDATE ⬆️

### NVFP4+INT8 ConvRot Hybrid — New Default
- Default diffusion models: **NVFP4+INT8 ConvRot hybrid** (`minimax_h3_fl2va_pruned_nvfp4_convrot_int8` / `minimax_h3_ref2va_pruned_nvfp4_convrot_int8`) from [lilcheaty/MiniMax-H3-NVFP4](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4) — NVFP4 on MLP, INT8 ConvRot on attention, BF16 on sensitive layers. Best speed/quality on Blackwell, ~2.5x faster than pure INT8 with identical visual quality
- Uncensored text encoder: **NVFP4** (`qwen3vl_32b_heretic_minimax_h3_nvfp4`) from [Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4) — fast on Blackwell, no quality impact on text encoding
- ⚠️ **Non-Blackwell GPUs**: Use pure INT8 ConvRot models from [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) instead. NVFP4 requires sm_120+ (RTX 5090 / PRO 6000).

### SOL-ATTN + Spectrum Integration
- All 4 Turbo workflows now include **SOL-ATTN** (Scheduled Sol Attention) for sharper output
- All 4 Turbo workflows now include **Spectrum** adaptive smoothing (offline replay disabled for speed)
- Turbo LoRA linked from preset to subgraph in all workflows

### Turbo Step Standardization
- All Turbo workflows standardized to **8 steps** (was 6 for T2VA/R2VA)
- Consistent `minimax_h3_turbo_v4_step600_ema` LoRA across all workflows

### TensorRT Batch Size
- RIFE and Upscaler TRT expose separate loader and runner `batch_size` parameters
- **Verified stable configuration**:
  - RIFE: loader `1`, runner `1`
  - Upscaler: loader `2`, runner `2`
- The **loader** compiles the TensorRT engine profile; the **runner** controls frames sent per `infer()` call (runner ≤ loader)
- RIFE batch values above 1 can build but currently fail during interpolation; keep RIFE at `1/1`
- Upscaler `2/2` is verified on RTX PRO 6000 Blackwell; batch 4 fails to build with TensorRT 10.15 on sm_120
- Changing the loader batch size requires a different engine; delete incompatible cached TRT engines before rebuilding

### Upscaler: Auto-detect Scale Factor
- Removed the `scale` dropdown (2x/4x) from the Upscaler runner node — it was redundant and error-prone
- The loader now **auto-detects** the upscale factor from the model name (`2x*` → 2, `4x*` → 4, `x2plus` → 2, `x4plus` → 4)
- The factor is passed to the runner via the engine object — no more mismatch between model and scale setting
- **Requires** `ComfyUI-Upscaler-TensorRT-Auto` updated to latest version

---

## ⚠️ Requirements — Read First!

### GPU & VRAM

- 🟢 **Recommended template configuration** — RTX 5090 (32 GB) / RTX PRO 6000 (48 GB) → NVFP4 diffusion + NVFP4 text encoder
- 🟡 **Non-Blackwell alternative** — RTX 4090 / 3090 (24 GB) → INT8 ConvRot + offload
- 🟠 **Lower-VRAM alternative** — 12–16 GB → INT4 + aggressive offload; slow and not recommended for production
- ⚠️ **NVFP4 requires Blackwell** (`sm_120+`) and does not run on RTX 4090/3090/4080

> **12 GB GPUs (e.g. RTX 3060 12GB)**: Technically possible with INT4 models + aggressive offloading, but **very slow**. You need 32 GB+ system RAM and a fast NVMe SSD. Not recommended for production use.

### Model Quantization Options

- **BF16 (full)** — Diffusion ~42 GB + Text encoder ~65 GB = ~110 GB total → [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **INT8 (pruned)** — Diffusion ~21 GB + Text encoder ~24.5 GB = ~50 GB total → [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **INT4 (pruned)** — Diffusion ~11 GB + Text encoder ~15 GB = ~24.5 GB total → [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)
- **NVFP4+INT8 ConvRot hybrid (recommended — verified)** — Diffusion ~20 GB + uncensored NVFP4 text encoder ~15.7 GB = ~36 GB active model set → [lilcheaty/MiniMax-H3-NVFP4](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4) + [Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4). Best speed/quality on Blackwell

### Software

- **ComfyUI**: v0.31.0+ (required for MiniMax H3 native support)
- **Python**: 3.10+
- **CUDA**: 12.8+ (13.0 recommended)
- **Storage**: allow at least 90 GB for the complete provisioned package (~81 GB of models plus engines, workflows and outputs)

### Qwen3-VL Prompt Enhancer

- **GGUF**: Q4_K_S (~4.8 GB) or Q5_K_S (~5.5 GB) for 8B model
- **HF**: Qwen3-VL-8B-Heretic-Stable (~16 GB) or Qwen3-VL-4B (~8 GB)

### ⚡ MiniMax-H3 Turbo LoRA (Optional — Faster & Sharper)

A distilled 8-step LoRA for MiniMax-H3 that replaces the default ~20-step sampling, with a dedicated ComfyUI node. All Turbo workflows now include **SOL-ATTN** (Scheduled Sol Attention) and **Spectrum** adaptive smoothing for sharper, smoother output.

- **Custom node**: [Larryvrh/ComfyUI-MiniMax-H3-Turbo](https://github.com/Larryvrh/ComfyUI-MiniMax-H3-Turbo)
- **SOL-ATTN node**: [Saganaki22/ComfyUI-sol-attn](https://github.com/Saganaki22/ComfyUI-sol-attn)
- **Spectrum node**: [xmarre/ComfyUI-Spectrum-MiniMax-H3](https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3)
- **Recommended LoRA**: `minimax_h3_turbo_v4_step600_ema.safetensors` (~744 MB)
- **Download**: [larryvrh/MiniMax-H3-Turbo-Lora](https://huggingface.co/larryvrh/MiniMax-H3-Turbo-Lora/resolve/main/minimax_h3_turbo_v4_step600_ema.safetensors)
- **Install**: place the `.safetensors` in `ComfyUI/models/loras/`
- **Usage**: 8 steps with scheduler `simple`, SOL-ATTN patch (1.3/0.8/linear/4096), Spectrum (blend_weight=0.5, offline_smoothing_replay=False)

Works with all tasks: T2VA, I2VA, FL2VA and R2VA.

---

## 🌟 What is ComfyUI-QwenVL-Mod?

A powerful enhanced vision-language node for ComfyUI that combines **Qwen3-VL** models with **MiniMax H3** video generation workflows. Features multilingual support, visual style detection, native stereo audio, and NSFW capabilities for professional AI content creation.

Think: *"Your all-in-one solution for intelligent prompt enhancement and video+audio generation with MiniMax H3!"*

---

## 🎬 Key Features

### 🚀 MiniMax H3 Video+Audio Generation

- **T2VA** (Text-to-Video+Audio): Generate video with native stereo audio from text
- **I2VA** (Image-to-Video+Audio): Animate a first-frame image with audio
- **FL2VA** (First-Last-Frame): Generate the transition between two keyframes — Qwen3-VL sees both frames
- **R2VA** (Reference-to-Video): Lock character identity, style, motion, or voice using reference images

### 🧠 Qwen3-VL Auto-Prompting

- **Multilingual**: Write your prompt in **any language** — Qwen3-VL translates and converts it
- **Auto-format**: Generates the official MiniMax H3 prompt format (3-field for base, 6-field for R2VA)
- **Multi-reference**: Qwen3-VL sees all connected images via `image` + `image2` inputs
- **Visual style detection**: 12+ artistic styles (photorealistic, cinematic, anime, 3D CG, claymation, vintage film, watercolor, fantasy, etc.)
- **Smart caching**: Performance optimization with Fixed Seed Mode
- **GGUF backend**: Efficient local model inference with quantization support
- **Qwen3.5 support**: Thinking mode disabled via `/no_think` for fast prompt generation

### 🔊 Native Stereo Audio

- **No separate audio node needed** — MiniMax H3 generates video and audio jointly in a single forward pass
- Voice, sound effects, and music modeled together, not layered on afterward
- Describe sounds in your prompt and the model generates them natively

### 🎨 NSFW Support

- Comprehensive content generation without restrictions
- 9 dedicated NSFW presets (3 base 🎬 + 3 R2VA 🎞️ + 3 FL2VA 🔄) with explicit diegetic soundscape
- Natural progression, style adaptation, consistent characters

---

## 📦 What's Included — 4 Turbo Workflows

All workflows are pre-wired with `MiniMax-H3 Turbo LoRA` + `MiniMax-H3 Turbo Sampler` at **8 steps** + SOL-ATTN + Spectrum.

1. ⚡ **T2VA Turbo** — `MiniMaxH3-Turbo-T2VA-Qwen3.5.json` — text only — Text-to-video+audio. Simplest workflow.
2. ⚡ **I2VA Turbo** — `MiniMaxH3-Turbo-I2VA-Qwen3.5.json` — text + first-frame image (`image`) — Image-to-video. First-frame animation with audio.
3. ⚡ **FL2VA Turbo** — `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` — text + first-frame (`image`) + last-frame (`image2`) — First-Last-Frame to video. Includes TensorRT upscale + RIFE frame interpolation for 48 fps output.
4. ⚡ **R2VA Turbo** — `MiniMaxH3-Turbo-R2VA-Qwen3.5.json` — text + reference images (`image` + `image2`) — Reference-to-video. Lock identity, style, motion, camera, or voice using up to 9 ref images.

> Workflows 3 and 4 include **TensorRT upscaling** and **RIFE frame interpolation** for 48 fps high-resolution output.

---

## 🖼️ Multi-Reference Input (image2)

The QwenVL-Mod node has two image inputs:

- **T2VA**: no images needed
- **I2VA**: `image` = first frame
- **FL2VA**: `image` = first frame, `image2` = last frame, `frame_count` = 1
- **R2VA**: `image` = primary reference, `image2` = additional references (batch, up to 9), `frame_count` = 1–9

> Qwen3-VL sees **all** connected images as individual images (not as a video sequence), enabling proper multi-reference analysis for FL2VA and R2VA.

---

## 🎯 QwenVL-Mod NSFW Presets (9 total)

The workflows include built-in NSFW presets for the Qwen3-VL prompt enhancer:

### 🎬 Base Presets (T2VA / I2VA)

- `🎬 MiniMax H3 NSFW (5s)` — 5 seconds — 3 fields: `integrated_multimodal_description` + `overall_soundscape` + `non_diegetic_music`
- `🎬 MiniMax H3 NSFW (10s)` — 10 seconds — Same format
- `🎬 MiniMax H3 NSFW (15s)` — 15 seconds — Same format

### 🔄 FL2VA Presets (First-Last-Frame)

- `🔄 MiniMax H3 NSFW FL2VA (5s)` — 5 seconds — 3 fields, transition-focused (describes the path between frames)
- `🔄 MiniMax H3 NSFW FL2VA (10s)` — 10 seconds — Same format
- `🔄 MiniMax H3 NSFW FL2VA (15s)` — 15 seconds — Same format

### 🎞️ R2VA Presets (Reference)

- `🎞️ MiniMax H3 NSFW R2VA (5s)` — 5 seconds — 6 fields: `subject_definitions` + `summary` + `retention_analysis` + `detailed_description` + `overall_soundscape` + `non_diegetic_music`
- `🎞️ MiniMax H3 NSFW R2VA (10s)` — 10 seconds — Same format
- `🎞️ MiniMax H3 NSFW R2VA (15s)` — 15 seconds — Same format

### What the presets produce

- 🎬 **Base**: `[Shot 1]` with style + initial composition, camera vocabulary, speaker IDs, diegetic soundscape
- 🔄 **FL2VA**: Describes the **transition path** between first and last frames (not the scene — images fix the scene). Favors single continuous shot.
- 🎞️ **R2VA**: 6-section format with `<Subject N>`, `<Picture N>`, `<Video N>`, `<Audio N>` labels, retention markers (`fully_preserved`, `partially_preserved`, etc.), task-type summary
- All presets: **smooth, continuous camera motion** (no abrupt or stepped changes), explicit diegetic soundscape, optional non-diegetic music (defaults to N/A)

> SFW presets are also available. Edit the preset dropdown in the QwenVL node to switch.

---

## 🎮 Usage Examples

### Basic Text-to-Video (T2VA)
1. Load `MiniMaxH3-Turbo-T2VA-Qwen3.5.json`
2. Write your prompt in any language
3. Select preset `🎬 MiniMax H3 NSFW (5s/10s/15s)`
4. Generate video with native audio

### Image-to-Video (I2VA)
1. Load `MiniMaxH3-Turbo-I2VA-Qwen3.5.json`
2. Upload your first-frame image to `image`
3. Select preset `🎬 MiniMax H3 NSFW (5s/10s/15s)`
4. Write what happens next (in any language)
5. Generate animated video with audio

### First-Last-Frame (FL2VA)
1. Load `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json`
2. Upload first-frame to `image`, last-frame to `image2`, set `frame_count=1`
3. Select preset `🔄 MiniMax H3 NSFW FL2VA (5s/10s/15s)`
4. Describe the transition between the two frames
5. Generate the interpolated video at 48 fps with TensorRT upscale + RIFE

### Reference-to-Video (R2VA)
1. Load `MiniMaxH3-Turbo-R2VA-Qwen3.5.json`
2. Upload primary reference to `image`, additional references to `image2` (batch), set `frame_count` to match
3. Select preset `🎞️ MiniMax H3 NSFW R2VA (5s/10s/15s)`
4. Reference them by tag in your prompt: `<Picture 1>`, `<Picture 2>`, etc.
5. Generate video with locked identity/style

---

## 🔧 Technical Specifications

### ⚡ Performance

- **Output**: 768p, 24 fps (native), up to ~15 seconds
- **Audio**: Native stereo, generated jointly with video
- **Upscale**: TensorRT RealESRGAN x4 (FL2VA + R2VA workflows)
- **Frame interpolation**: RIFE v4.25 → 48 fps (FL2VA + R2VA workflows)
- **Sage Attention**: FP16 accumulation, async offload
- **Smart caching**: Reuse prompts with same inputs, Fixed Seed Mode for text-only caching

### 🎨 Model Support

- **Qwen3-VL 4B**: 7 GGUF variants (2.38 GB – 4.28 GB)
- **Qwen3-VL 8B**: 7 GGUF variants (4.8 GB – 8.71 GB)
- **Qwen3.5**: 4B / 9B / 27B (uncensored, heretic, unsloth) — thinking mode disabled
- **HF Models**: Josiefed, official, Heretic-Stable variants
- **Quantization**: Q4_K_S, Q5_K_S, FP16, INT8

### 🌐 Multilingual Capabilities

- **Input languages**: Any language supported
- **Auto-translation**: Automatic translation to optimized English
- **Style detection**: Works with multilingual prompts
- **Cultural adaptation**: Context-aware prompt enhancement

---

## 📦 Installation

### Quick Install

1. Download: [ComfyUI-QwenVL-Mod](https://github.com/huchukato/ComfyUI-QwenVL-Mod) (latest version)
2. Extract to `ComfyUI/custom_nodes/ComfyUI-QwenVL-Mod`
3. Install requirements: `pip install -r requirements.txt`
4. Restart ComfyUI
5. Load included workflows from `minimax/` folder

### Custom Nodes Required

- **ComfyUI-QwenVL-Mod** — All workflows (Qwen3-VL prompt enhancer) — [huchukato/ComfyUI-QwenVL-Mod](https://github.com/huchukato/ComfyUI-QwenVL-Mod)
- **ComfyUI-MiniMax-H3-Turbo** — Turbo workflows (Turbo LoRA + Sampler) — [Larryvrh/ComfyUI-MiniMax-H3-Turbo](https://github.com/Larryvrh/ComfyUI-MiniMax-H3-Turbo)
- **ComfyUI-sol-attn** — Turbo workflows (SOL-ATTN, FusedModulation, ChunkFeedForward) — [Saganaki22/ComfyUI-sol-attn](https://github.com/Saganaki22/ComfyUI-sol-attn)
- **ComfyUI-Spectrum-MiniMax-H3** — Turbo workflows (adaptive smoothing) — [xmarre/ComfyUI-Spectrum-MiniMax-H3](https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3)
- **ComfyUI-RIFE-TensorRT-Auto** — FL2VA, R2VA (frame interpolation) — [huchukato/ComfyUI-RIFE-TensorRT-Auto](https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto)
- **ComfyUI-Upscaler-TensorRT-Auto** — FL2VA, R2VA (upscaling) — [huchukato/ComfyUI-Upscaler-TensorRT-Auto](https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto)
- **ComfyUI-VideoHelperSuite** — FL2VA, R2VA (VHS_VideoCombine) — [Kosinkadink/ComfyUI-VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- **ComfyUI-Easy-Use** — FL2VA, R2VA (easy showAnything) — [yolain/ComfyUI-Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use)
- **comfyui-find-perfect-resolution** — All workflows (ResolutionSelector) — [ashtar1984/comfyui-find-perfect-resolution](https://github.com/ashtar1984/comfyui-find-perfect-resolution)

> **Note**: `ComfyMathExpression` is built into ComfyUI core (v0.24.1+) — no custom node needed.

### Models Required

**T2VA / I2VA / FL2VA** use the NVFP4 **FL2VA** model (Blackwell GPUs):

- `models/vae/` → `minimax_h3_video_vae_fp16.safetensors` (~5 GB)
- `models/vae/` → `minimax_h3_audio_vae_fp32.safetensors` (~0.6 GB)
- `models/diffusion_models/` → `minimax_h3_fl2va_pruned_nvfp4_convrot_int8.safetensors` (~20 GB) — [lilcheaty/MiniMax-H3-NVFP4](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4)
- `models/text_encoders/` → `qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors` (~15.7 GB) — [Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4)

**R2VA (ref2va)** uses the NVFP4 Ref2VA model:

- `models/diffusion_models/` → `minimax_h3_ref2va_pruned_nvfp4_convrot_int8.safetensors` (~20 GB) — [lilcheaty/MiniMax-H3-NVFP4](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4)

> **Non-Blackwell GPUs**: Use INT8 ConvRot models from [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) instead. NVFP4 requires sm_120+ (RTX 5090 / PRO 6000).

**10Eros-Max NVFP4 (optional/experimental)**

- `models/diffusion_models/` → `10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors` (~23.5 GB)
- Pair it only with `minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors` (~1.96 GB)
- Switch both diffusion model and matching LoRA together; do not mix the standard and 10Eros LoRAs
- The standard MiniMax H3 NVFP4+INT8 hybrid is the verified default. 10Eros-Max remains experimental; NVFP4 HQ degrades quality and audio on the 10Eros fine-tune, so INT8 ConvRot HQ is used instead

**Turbo LoRA (standard — all tasks)**

- `models/loras/` → `minimax_h3_turbo_v4_step600_ema.safetensors` (~744 MB)
- **Custom node**: [Larryvrh/ComfyUI-MiniMax-H3-Turbo](https://github.com/Larryvrh/ComfyUI-MiniMax-H3-Turbo)

**INT4 alternative** (for 12-16 GB GPUs): [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)

**Qwen3-VL Prompt Enhancer**

- `models/LLM/` → `Qwen3-VL-8B-Heretic-Stable` (GGUF or HF)

**TensorRT Engines (FL2VA + R2VA only)**

- `models/upscale_models/` → `RealESRGAN_x4` (TensorRT engine)
- `models/rife/` → `rife425_ensemble_False_scale_1_sim` (TensorRT engine, ONNX auto-downloaded from HF)

> TensorRT engines must be built for your specific GPU. See [ComfyUI-RIFE-TensorRT-Auto](https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto) and [ComfyUI-Upscaler-TensorRT-Auto](https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto) for build instructions.

### Download Links

- **VAE**: [video_vae_fp16](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors) · [audio_vae_fp32](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors)
- **Diffusion (fl2va, NVFP4+INT8 hybrid — Blackwell)**: [minimax_h3_fl2va_pruned_nvfp4_convrot_int8.safetensors](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4/resolve/main/minimax_h3_fl2va_pruned_nvfp4_convrot_int8.safetensors)
- **Diffusion (ref2va, NVFP4+INT8 hybrid — Blackwell)**: [minimax_h3_ref2va_pruned_nvfp4_convrot_int8.safetensors](https://huggingface.co/lilcheaty/MiniMax-H3-NVFP4/resolve/main/minimax_h3_ref2va_pruned_nvfp4_convrot_int8.safetensors)
- **Diffusion (fl2va, INT8 — non-Blackwell)**: [minimax_h3_fl2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors)
- **Diffusion (ref2va, INT8 — non-Blackwell)**: [minimax_h3_ref2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors)
- **Text encoder (uncensored, NVFP4 — Blackwell)**: [qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4/resolve/main/qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors)
- **Text encoder (official, INT8 alternative)**: [qwen3vl_32b_minimax_h3_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_int8_convrot.safetensors)
- **Turbo LoRA (standard)**: [minimax_h3_turbo_v4_step600_ema.safetensors](https://huggingface.co/larryvrh/MiniMax-H3-Turbo-Lora/resolve/main/minimax_h3_turbo_v4_step600_ema.safetensors)
- **10Eros-Max diffusion (optional/experimental, INT8 HQ)**: [10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors](https://huggingface.co/DmitryDB/MiniMax-H3-10Eros-Max-Quants/resolve/main/FL2VA/10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors)
- **10Eros-compatible Turbo LoRA**: [minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors](https://huggingface.co/t8star/minimax_h3_turbo_4step_10ErosMax_test4_pruned_curveproj1025_T8/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors)
- **INT4 models**: [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)

---

## 🎬 MiniMax H3 Prompting Notes

### How to Write Your Prompt

Describe the scene naturally. Be clear about the concepts below — Qwen3-VL handles the rest:

- **🎨 Visual style** (put it first): `photorealistic`, `cinematic`, `anime`, `3D CG`, `claymation`, `vintage film`, `watercolor`, `fantasy`
- **👥 Subjects**: number, gender, appearance, clothing, position, expression
- **🏃 Action / motion**: what happens, speed, interaction
- **🎥 Camera**: dolly, pan, zoom, static, handheld, crane, orbit — **smooth and continuous** (no abrupt changes)
- **🌍 Environment**: setting, lighting, atmosphere, time of day
- **🔊 Audio** (important!): dialogue, breaths, moans, skin contact, ambient sounds, music

> 🔄 **FL2VA**: Describe the **transition** between frames, not the scene (images fix the scene)
> 🎞️ **R2VA**: Reference inputs by tag: `<Picture 1>`, `<Picture 2>`, `<Video 1>`, `<Audio 1>`

### Resolution Guidance

MiniMax H3 native canvas: **768 px short edge**, long edge capped at **1344 px**, multiples of **32**.

- 📱 **Portrait**: 768×1344 · 896×1152 · 960×1280
- ⬛ **Square**: 1024×1024
- 🖥️ **Landscape**: 1344×768 · 1152×896 · 1280×960

> ⚠️ **Match the aspect ratio to your input image!** Forcing 16:9 on a portrait image will squash it.
>
> ⚠️ **Avoid direct 1080p.** Generate at native resolution, then upscale with TensorRT nodes (FL2VA + R2VA workflows).

### Duration

Choose a preset: **5s / 10s / 15s**. The Math Expression node snaps the frame count to the model's 17-frame-per-block grid (17k+5 at 24 fps).

---

## 🐳 Docker / Cloud Ready

### OneClick RunPod Template

Prefer a ready-to-go environment? Use the **OneClick - ComfyUI - MiniMax H3 Turbo - Qwen3VL** RunPod template:

- **Docker image**: `huchukato/comfyui-qwenvl-runpod:cu13-mmh3`
- **Base**: `runpod/comfyui:cuda13.0`
- All custom nodes pre-installed
- All 4 Turbo workflows auto-downloaded at boot
- Models auto-downloaded at first boot (~81 GB including INT8 diffusion, NVFP4 text encoder, 10Eros INT8 HQ and Turbo LoRAs; persistent)
- ComfyUI v0.33.1+ forced at boot
- Sage Attention, FP16 accumulation, async offload
- TensorRT upscaling + RIFE interpolation (stable defaults: Upscaler `2/2`, RIFE `1/1`)
- SOL-ATTN + Spectrum for Turbo workflows

> **Access**: ComfyUI `:8188` · JupyterLab `:8888` · FileBrowser `:8080` (user `admin` / password `adminadmin12`) · SSH `ssh root@pod-ip`

[📖 README & instructions](https://github.com/huchukato/ComfyUI-QwenVL-Mod/blob/main/runpod/README_MiniMaxH3.md)

### ComfyUI Args (pre-configured)

```
--disable-auto-launch
--fast fp16_accumulation
--use-sage-attention
--reserve-vram 2
--cuda-malloc
--async-offload
```

---

## 🚀 Why Choose ComfyUI-QwenVL-Mod + MiniMax H3?

### 🎬 For Content Creators
- **Native audio**: Video and audio in one pass — no separate MMAudio needed
- **Multilingual**: Write in any language, Qwen3-VL handles translation
- **Professional**: Official MiniMax H3 prompt format with camera vocabulary and speaker tags
- **Quality**: 768p native, TensorRT upscale to higher resolution

### 🔥 For NSFW Content
- **Explicit**: Uncensored generation with dedicated NSFW presets
- **9 presets**: 3 base 🎬 + 3 FL2VA 🔄 + 3 R2VA 🎞️ — each tuned for its mode
- **Detailed**: Rich scene descriptions with explicit diegetic soundscape
- **Natural**: Realistic progression, consistent characters
- **Audio**: Native moans, breaths, skin contact, ambient sounds

### ⚡ For Power Users
- **Customizable**: Easy to modify presets and system prompts
- **Extendable**: Add your own Qwen3-VL models (GGUF or HF)
- **Integrable**: Works with existing ComfyUI setups
- **Optimized**: Sage Attention, FP16, async offload, smart caching
- **Multi-reference**: `image2` input for FL2VA and R2VA workflows

---

## 🌟 What Makes This Special?

- **First**: Complete MiniMax H3 workflow pack with Qwen3-VL auto-prompting
- **Native audio**: No separate audio node — MiniMax H3 does it all
- **4 Turbo workflows**: T2VA, I2VA, FL2VA, R2VA — covers all MiniMax H3 modes
- **Multi-reference**: Qwen3-VL sees all connected images (not just the first)
- **TensorRT**: Built-in upscaling and frame interpolation
- **9 NSFW presets**: Dedicated presets for each mode with correct prompt structure
- **Multilingual**: Any input language, auto-translated and formatted
- **Ready**: Works out-of-the-box with included workflows

---

## 🎯 What's New in v2.6.0

### ⚡ NVFP4+INT8 ConvRot Hybrid — New Default
- ✅ Default diffusion models: **NVFP4+INT8 ConvRot hybrid** (`minimax_h3_fl2va_pruned_nvfp4_convrot_int8` / `minimax_h3_ref2va_pruned_nvfp4_convrot_int8`)
- ✅ ~2.5x faster than pure INT8 ConvRot with identical visual quality on Blackwell
- ✅ NVFP4 on MLP, INT8 ConvRot on attention, BF16 on sensitive layers (by rockerBOO/lilcheaty)
- ✅ NVFP4 requires Blackwell GPUs (RTX 5090 / PRO 6000, sm_120+)
- ✅ Pure INT8 ConvRot models still available for non-Blackwell GPUs

### 🔧 SOL-ATTN + Spectrum Integration
- ✅ All 4 Turbo workflows now include **SOL-ATTN** (Scheduled Sol Attention) for sharper output
- ✅ All 4 Turbo workflows now include **Spectrum** adaptive smoothing (offline replay disabled for speed)
- ✅ Turbo LoRA linked from preset to subgraph in all workflows

### ⚡ Turbo Step Standardization
- ✅ All Turbo workflows standardized to **8 steps** (was 6 for T2VA/R2VA)
- ✅ Consistent `minimax_h3_turbo_v4_step600_ema` LoRA across all workflows

### 📦 TensorRT Batch Size
- ✅ Stable defaults: RIFE loader/runner `1/1`, Upscaler loader/runner `2/2`
- ✅ Upscaler `2/2` verified on RTX PRO 6000 Blackwell
- ⚠️ RIFE batch >1 currently fails during interpolation even when the engine builds; keep it at `1/1`
- ⚠️ Upscaler batch 4 fails to build with TensorRT 10.15 on Blackwell sm_120

### 🧹 Cleanup
- ✅ Removed `was-node-suite` from MiniMax Dockerfile (not used by MiniMax workflows)
- ✅ Removed `ComfyUI-Frame-Interpolation` from MiniMax (uses RIFE TensorRT instead)
- ✅ Removed `KJNodes` from provisioning (baked into RunPod base image)
- ✅ `ComfyMathExpression` is built into ComfyUI core — no custom node needed

### 🧠 Qwen3.5 Thinking Fix
- ✅ `/no_think` prefix for Qwen3.5 models (enable_thinking deprecated in recent llama.cpp)
- ✅ Broadened architecture detection (qwen35, qwen35moe, qwen35_vl)
- ✅ Works across both HF and GGUF nodes

### 📦 Workflow Organization
- ✅ Moved workflows to `minimax/` folder
- ✅ Renamed FLF to FL2VA (clearer naming)
- ✅ Added Civitai documentation

---

## 📋 Credits

- **MiniMax H3** — [MiniMax](https://www.minimax.io/blog/minimax-h3) · [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **ComfyUI** — [comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **QwenVL-Mod** — [huchukato/ComfyUI-QwenVL-Mod](https://github.com/huchukato/ComfyUI-QwenVL-Mod)
- **Qwen3-VL** — [Qwen Team / Alibaba](https://github.com/QwenLM/Qwen3-VL)
- **INT4 models** — [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)
- **TensorRT RIFE / Upscaler** — [huchukato](https://github.com/huchukato)
- **SOL-ATTN** — [Saganaki22](https://github.com/Saganaki22/ComfyUI-sol-attn)
- **Spectrum** — [xmarre](https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3)
- **VideoHelperSuite** — [Kosinkadink](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- **Easy-Use** — [yolain](https://github.com/yolain/ComfyUI-Easy-Use)
- **find-perfect-resolution** — [ashtar1984](https://github.com/ashtar1984/comfyui-find-perfect-resolution)

---

## 📄 License

Workflows are released under the same license as the underlying models and custom nodes. See each repository for details.

MiniMax H3 model weights: [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) — MiniMax H3 Community License.

---

Built with ❤️ for the ComfyUI community
