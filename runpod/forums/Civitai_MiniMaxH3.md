# [MiniMax H3] NSFW T2VA/I2VA/FL2VA/R2VA Workflows 🎬 Auto Prompt | Native Audio | TensorRT Upscale | RIFE Interpolation

![MiniMax H3 Qwen3VL](https://raw.githubusercontent.com/huchukato/ComfyUI-QwenVL-Mod/main/img/bannerminimax.png)

ComfyUI-QwenVL-Mod — Enhanced Vision-Language with MiniMax H3
Version 2.12.2 (2026/10/23) — 🎬 Director Native + Storyboard + ⚡ Singularity fused R2VA checkpoint + 🎬 MiniMax H3 Native Video+Audio + INT8 ConvRot + Comfy Kitchen Attention + Native Block Sparse Attention + lightx2v Turbo LoRA + Wildcards + 10Eros-Max Support + Camera Tag Dropdown + Unified FL2VA Loop + Qwen Workflow Chat + ForgeHub / Runpod Serverless

---

## 🚀 No GPU? Run it on Runpod Serverless

**ForgeHub** — desktop app (macOS / Windows / Linux) that drives this whole stack: recipe UI, `mmh3/` wildcards, reference image + video upload, style LoRA selector, QwenVL prompt enhancer, and a chat that writes MiniMax H3 spec prompts for you.

⬇️ [Download ForgeHub](https://github.com/huchukato/ForgeHub/releases) · ⚡ [Deploy the worker on Runpod](https://console.runpod.io/hub/listing/huchukato/runpod-minimax-h3?ref=ioakclrv)

Deploy the endpoint → attach a ≥160 GB network volume → paste the endpoint ID into ForgeHub settings → generate. All models auto-download on first boot.

**Prefer a full ComfyUI pod instead?** Same stack, one click:

- 🟣 [RunPod — ComfyUI MiniMax H3 pod template](https://console.runpod.io/hub/template/bii5d425kp?ref=ioakclrv)
- 🔵 [Vast.ai — OneClick ComfyUI MiniMax H3 Turbo Uncensored + Qwen3.5 AutoPrompt](https://cloud.vast.ai/?ref_id=188688&creator_id=188688&name=OneClick%20-%20ComfyUI%20-%20MiniMax%20H3%20Turbo%20Uncensored%20-%20Qwen3.5%20AutoPrompt)

**Want both stacks (video + Qwen Image 2.1 image gen/edit)?**

- 🟣 [RunPod — ComfyUI MiniMax H3 + Qwen Image 2.1 pod template](https://console.runpod.io/hub/template/janme4pbim?ref=ioakclrv)
- 🔵 [Vast.ai — OneClick ComfyUI MiniMax H3 + Qwen Image 2.1 — Qwen 3.5 Autoprompt](https://cloud.vast.ai/?ref_id=749134&creator_id=749134&name=OneClick%20-%20ComfyUI%20-%20MiniMax%20H3%20%2B%20Qwen%20Image%202.1%20-%20Qwen%203.5%20Autoprompt)

---

## ⬆️ 2026/10/23 UPDATE ⬆️

### 🎬 MiniMax H3 Director — Two New Workflows

The pack adds the **Director pair** — timeline-driven multi-scene videos with audio, powered by the new **MiniMaxH3-Director** custom node (auto-installed with the pack):

- **Director-Native** (`MiniMaxH3-Director-Native-Qwen3.5.json`): character sheet + **ideas one per line** (each line = a segment) → the Director compiles the full timeline prompt itself. **Auto-Analyze** builds the subject description from the sheet; the built-in QwenVL **Enhance** expands each segment. The **compiled prompt is what runs** — visible in the ShowText node
- **Director-Storyboard** (`MiniMaxH3-Director-Storyboard-Qwen3.5.json`): generate up to **3 scene stills** with `QwenImageEdit21-Wildcards` (preset `IMG › Storyboard`), load them chronologically — the in-graph QwenVL turns stills + idea into the final R2VA prompt (`external_prompt`), the Director renders it with the stills as references
- **Singularity Turbo baked in both**: `euler` + `beta` + 6 steps + `minimax_h3_ref2v_turbo_4step` at strength 1.0 — the `config` dropdown switches to the 20-step quality preset
- **References switch** (Native): `REF2VA` (Refs ON — the sheet drives identity, default) / `OFF` (text-only, fl2va path)
- **Style dropdown** like Singularity: `[MATCH REF1]` follows the reference's art style, or force one (cinematic, anime2d, claymation, …) — expands via the `mmh3/style/` wildcards
- Requires **QwenVL-Mod ≥ 2.12.2** (GGUF import fix — nodes register cleanly even without llama-cpp-python)

### 🖼️ ForgeHub v0.1.18

Both Director workflows ship in the ForgeHub form: charsheet upload, ideas field, style/config dropdowns, resolution picker, and the **prompt trace** showing the compiled prompt after every run. [Download ForgeHub](https://github.com/huchukato/ForgeHub/releases)

---

## ⬆️ 2026/10/07 UPDATE ⬆️

### ⚡ Singularity — One Fused Checkpoint for R2VA

The R2VA stack now runs on **WarmBloodAban's Singularity ref2va fusion** (`Minimax-h3_Singularity_ref2va_Pruned_v1.3_int8.safetensors`, ~21 GB) — [WarmBloodAban/Minimax-h3_Singularity](https://huggingface.co/WarmBloodAban/Minimax-h3_Singularity):

- **One checkpoint for T2V / I2V / R2V / V2V** — reference conditioning is fused into the weights
- ⚠️ **Do NOT attach the rank-256 reference LoRA** — it's baked into the fusion and breaks the style. Native R2VA on the plain `ref2va` checkpoint still needs it, Singularity does not
- Up to **3 reference images + 1 optional reference video**; a single image works fine and behaves like I2V
- Optional **style LoRA slots** baked into the workflows: `h3-realism-people-t2v-i2v-r2v` and `h3_character_swap_pro4500_1000` (set strength 0 / node off to disable)

### 🎚️ Correct Turbo Settings — `euler` + `simple`

Per the official lightx2v spec, the 8-step turbo LoRAs want **`euler` sampler + `simple` scheduler** with `MiniMaxH3SigmaShift` at **6/3** (768p training grid). `er_sde`/`beta` pairings floating around are for other LoRAs — don't use them here.

### 🚀 ForgeHub + Runpod Serverless

The whole MMH3 stack now also ships as a **serverless worker on the Runpod Hub** — zero local GPU required:

- Hub listing: [huchukato/runpod-minimax-h3](https://console.runpod.io/hub/listing/huchukato/runpod-minimax-h3) — one-click endpoint deploy, attach a ≥160 GB network volume and the models auto-populate
- **ForgeHub** desktop app drives it: recipe UI, wildcard quick-insert (`mmh3/` TagForge wildcards), reference image/video upload, style LoRA selector, QwenVL prompt enhancer toggle, and a recipe-aware chat that writes MiniMax H3 spec prompts for you
- Presets shipped in-app: `r2va_singularity` (20 steps res_multistep/simple, shift 4/3) and `r2va_singularity_turbo` (8 steps euler/simple, shift 6/3, ref2v turbo LoRA)

### 🧠 Prompt Enhancer — Two Tips

- Hand-written spec prompts (the `subject_definitions`/`detailed_description` format): **disable the enhancer** — passthrough keeps your exact structure; the enhancer preset rewrites it and can drop your `<Picture N>` bindings
- `keep_model_loaded` keeps the GGUF enhancer resident between runs — worth it on big-VRAM cards if you use it every job

---

## ⬆️ 2026/10/02 UPDATE ⬆️

### ⚡ Workflow Stack Cleanup

- **Comfy Kitchen Attention** is now wired directly into every safetensors workflow between `LoraLoader` and `BlockSparseAttention`
- **SeedVR2 removed completely** from the MiniMax H3 workflow pack; TensorRT upscaling now receives frames directly
- The redundant **I2VA-V2VA workflow has been retired**
- The pack now ships **4 workflows**: T2VA, I2VA, FL2VA, and R2VA — seamless looping lives inside FL2VA via the "Loop Trim" bypass group
- Vast.ai provisioning has been aligned with the current workflow set

### 🧠 QwenVL-Mod 2.10.2

- The completed hackathon-only **Livepeer Agent integration has been removed**
- Qwen Workflow Chat and the standard HF/GGUF prompt-enhancement pipeline remain fully available

---

## ⬆️ 2026/09/27 UPDATE ⬆️

### 🔄 Pure INT8 ConvRot — NVFP4 Removed

The MMH3 setup now uses pure INT8 ConvRot models. NVFP4 was removed after testing showed a noticeable quality loss. Speed comes from Turbo LoRAs, sparse attention, and the Triton backend.

- **FL2VA DiT**: `minimax_h3_fl2va_pruned_int8_convrot.safetensors` (~21 GB) — [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **R2VA DiT**: `minimax_h3_ref2va_pruned_int8_convrot.safetensors` (~21 GB) — [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **Uncensored H3 text encoder**: `qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors` (~15 GB, full conditioning encoder) — [Momoking](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4)
- **R2VA Native LoRA**: `minimax_h3_ref_lora_rank_256_bf16.safetensors` (~2.6 GB; required for native R2VA on the plain `ref2va` checkpoint — **NOT on Singularity**, where it is fused) — [Kijai](https://huggingface.co/Kijai/MiniMax-H3-experimental)
- **Singularity R2VA DiT** ⭐: `Minimax-h3_Singularity_ref2va_Pruned_v1.3_int8.safetensors` (~21 GB, fused T2V/I2V/R2V/V2V) — [WarmBloodAban/Minimax-h3_Singularity](https://huggingface.co/WarmBloodAban/Minimax-h3_Singularity)
- **10Eros**: `10Eros_Max_h3_hybrid_beta5_int8.safetensors` is a non-turbo checkpoint; use `lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned.safetensors` for Turbo

### ⚙️ ComfyUI Launch Arguments

```text
--highvram --disable-auto-launch --fast fp16_accumulation --enable-triton-backend --force-fp16
```

### 🔗 Model Chain — Order Matters

`UNETLoader (INT8)` → `LoraLoader` → `ModelAttentionBackend` (Comfy Kitchen Attention) → `BlockSparseAttention` (sol-attn) → `MiniMaxH3SigmaShift` → `BasicGuider` (CFG 1.0) → `SamplerCustomAdvanced`

If `ModelAttentionBackend` is missing from a workflow, add it manually between `LoraLoader` and `BlockSparseAttention`.

### 🎚️ Definitive Preset Table

| Preset | Steps | CFG | Video Shift | Audio Shift | Tau | LoRA (strength 1.0) |
|---|---:|---:|---:|---:|---:|---|
| Native Base (FL2VA) | 28–32 | 1.0 | 6.0 | 3.0 | 1.00 | Bypassed |
| Native Turbo (FL2VA) | 8 | 1.0 | 12.0 | 4.0 | 1.30 | `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16` |
| R2VA Native | 25–30 | 1.0 | 4.0 | 3.0 | 1.00 | `minimax_h3_ref_lora_rank_256_bf16` |
| R2VA Turbo | 8 | 1.0 | 6.0 | 3.0 | 1.30 | `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16` — `euler` + `simple` |
| **R2VA Singularity** ⭐ | 20 | 1.0 | 4.0 | 3.0 | 1.00 | **None — ref is fused in the checkpoint** (`res_multistep` + `simple`) |
| **R2VA Singularity Turbo** ⭐ | 6 | 1.0 | off | off | 1.30 | `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16` — `euler` + `beta` |
| 10Eros Max Beta5 | 30–40 | 1.0 | 6.0 | 3.0 | 0.85–1.00 | Bypassed |
| 10Eros Turbo | 8 | 1.0 | 12.0 | 4.0 | 1.30 | `lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned` |

---

## ⬆️ 2026/09/23 UPDATE ⬆️

### ⚡ Native Block Sparse Attention — No Custom Node Required

All Turbo workflows now use the **built-in ComfyUI `BlockSparseAttention` node** instead of the custom `ComfyUI-sol-attn` pack (removed from GitHub upstream). The acceleration is identical — the native node runs the same sol-attn path:

- **Same speed as the custom node** (verified A/B on Blackwell at 8 and 20 steps)
- **Method `sol-attn`, tau 1.3** — same threshold as before
- `sink_conditioning: exact_kv_and_rows` protects text/audio/reference rows natively
- `FusedModulation` and `ChunkFeedForward` dropped — no measurable speed difference
- **Nothing to install**: works on stock ComfyUI ≥ 0.30, zero extra custom nodes

### 💬 Qwen Chat + Prompt Pipeline

- **New default chat model**: `GGUF: Qwen3.5-9B-Defiant-Fable-Uncnr-Heretic-NEO-MAX-Q8_0` — sharper uncensored routing
- **MiniMax output normalization** (QwenVL-Mod ≥ 2.8.14): the enhancer now strips duplicated `[Shot N]` blocks before `integrated_multimodal_description` and auto-inserts the required I2VA reference-binding line (`For the target video...`) when missing — on **both HF and GGUF backends**
- **Preset-family routing fixed**: asking "10 seconds" inside an FL2VA or R2VA workflow now keeps the same mode instead of falling back to the generic preset

> 📌 Requires **QwenVL-Mod ≥ 2.8.14** (ComfyUI Manager → Update, or `git pull`).

---

## ⬆️ 2026/09/21 UPDATE ⬆️

### 🧠 Unified HF/GGUF QwenVL Nodes + Qwen 3.8 Default

All workflows now ship with the **new unified QwenVL nodes** — a single node with a `backend` dropdown instead of separate HF and GGUF nodes:

- **Backend dropdown**: switch between `HF transformers` and `GGUF llama.cpp` in one click — no more rewiring the graph to change backend
- **GGUF default**: workflows now default to `GGUF: Qwen3.8-9B-heretic-uncensored.Q8_0.gguf` — faster load, lower VRAM, uncensored out of the box
- Existing HF workflows still work; the dropdown also accepts any GGUF you drop in `models/LLM` (auto-discovery, no JSON editing)

### 💬 Qwen Workflow Chat + Livepeer Agent Render

The pack's companion features kept evolving (see the [QwenVL-Mod repo](https://github.com/huchukato/ComfyUI-QwenVL-Mod) for the full changelog):

- **Qwen Chat sidebar**: inspects the loaded workflow, edits widgets, picks presets and queues renders from natural language — understands the MiniMax H3 acceleration stack (Sol-Attn tau, Turbo LoRA, native steps) and switches configs like "10Eros", "Native" or "Turbo" on request
- **Livepeer Agent render node** (`QwenVL_LivepeerRender`): optional node that renders images/videos through the Livepeer Agent network via MCP, with a `source_video` frame picker for i2v references — the chat drives it directly

> 📌 Requires **QwenVL-Mod ≥ 2.8.0** (ComfyUI Manager → Update, or `git pull`). Older versions will show the new unified nodes as missing until updated.

---

## ⬆️ 2026/09/16 UPDATE ⬆️

### 🚫 Acceleration Stack Simplified — Spectrum + DiffAid Removed

Testing confirmed that **Spectrum's block wrapper is code-incompatible** with Sol fused blocks (crash: `unexpected keyword argument 'attention'`, verified at 20 steps), and **DiffAid showed no confirmed benefit**. Both node packs have been **removed from the stack entirely** — they are no longer shipped or required.

- **Sol-Attn is now the only acceleration patch** and stays active in ALL modes:
  - **10Eros TURBO**: tau 1.30
  - **Turbo LoRA**: tau 1.30 (FL2VA) / 1.30 (R2VA)
  - **Native**: tau 1.00
- **Sol-Fusion + Sol-FFN** stay always ON (50 blocks / 52 MLPs)
- The old "bypass Sol-Attn with Turbo" rule is superseded — high-tau Sol-Attn works fine on turbo
- Workflows updated: no Spectrum/DiffAid nodes required anymore

### 💬 Workflow-Aware Qwen Chat

The Qwen chat assistant is now **workflow-aware** — it reads the loaded workflow's widgets and can act on them directly:

- **Edit widgets from chat**: ask "change steps to 20" or "rewrite the prompt" and the assistant applies `set_widget_value` / `bypass` / `queue_workflow` actions on the real nodes — no manual clicking
- **Preset-aware**: injects the system guide of the preset selected in the workflow (e.g. MiniMax H3 NSFW 5s/10s/15s), so answers match the actual preset rules
- **Duration switching**: ask for a different clip length ("make it 10 seconds") and it picks the matching duration preset and updates the length/frame widgets automatically
- **Full prompt echo**: when it rewrites a prompt widget, the complete new text is repeated verbatim in the reply — no hidden truncation
- **Choice buttons**: for ambiguous requests (e.g. Turbo LoRA vs native) it asks first with clickable options instead of guessing
- **Knows the acceleration stack**: understands the Sol-Attn modes and tau values, so "switch to native quality" sets sampler, steps, shift and tau correctly

Also in this update: **Qwen3.5 native support** — the new `qwen3_5` architecture (hybrid linear/full attention) requires `transformers>=5.2.0`; older releases fail with "model type `qwen3_5` not recognized".

---

## ⬆️ 2026/09/04 UPDATE ⬆️

### 🔧 Turbo LoRA Switch — larryvrh → lightx2v 8-step 768p

All Turbo workflows now use **lightx2v Turbo LoRA 8-step 768p** (Apache-2.0) instead of larryvrh v4-600:

- **FL2VA**: `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors` (~1.96 GB)
- **Ref2VA**: `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors` (~1.96 GB)
- **No custom node required** — standard ComfyUI LoRA loader works
- Removed `Larryvrh/ComfyUI-MiniMax-H3-Turbo` custom node
- Trained at 1344×768 — matches our native resolution exactly

### 🚫 Acceleration Patch Rules with Turbo — Verified

Community testing informed the acceleration rules (see the 2026/09/16 update for the current stack):

- **Sol-Attn on Turbo LoRA**: tau 1.30 is the verified value at 8 steps (per the preset table). On 10Eros turbo the same tau applies
- **Spectrum** was removed from the stack — code-incompatible with Sol fused blocks
- **Rule**: Sol-Attn stays on in every mode, only the tau changes

**Turbo**: Turbo LoRA ON · Sol-Attn tau 1.30 · `euler` + `simple` · 8 steps, shift 12/4 (FL2VA) o 6/4 (R2VA)
**Native**: Turbo LoRA OFF · Sol-Attn tau 1.00 · `res_multistep` + `simple` · 28-32 steps, shift 6/3

### 🔄 10Eros-Max Switch — DmitryDB → cicalooo TURBO Hybrid Beta3

The 10Eros-Max model has been switched to **cicalooo's ComfyUI-native INT8 ConvRot Turbo Hybrid Beta3**:

- **Model**: `10Eros_Max_h3_TURBO-hybrid_beta3_int8_convrot_skip_edges.safetensors` (~22.5 GB)
- **TURBO fused in checkpoint** — no separate t8star LoRA needed
- Boundary blocks 0, 1, 48, 49 left in BF16 for stability
- Removed DmitryDB 10Eros model + t8star compatibility LoRA

### ⚡ Comfy Kitchen Attention — Replaces SageAttention

All MMH3 Docker/provisioning now uses **`--use-ck-attention`** (Comfy Kitchen Attention) instead of `--use-sage-attention`:

- Faster on Blackwell (RTX 5090 / PRO 6000)
- Better detail preservation
- No separate SageAttention package needed

---

## ⬆️ 2026/09/02 UPDATE ⬆️

### 🎥 Camera Tag Dropdown (19 movements)

The QwenVL node now has a **`camera_tag` dropdown** — no more typing `[ORBIT]` manually in the prompt. Select from 19 camera movements directly in the node UI:

| Category | Tags |
|---|---|
| Static | `[STATIC_CAMERA]`, `[LOCKED_OFF]` |
| Slow zoom | `[SLOW_ZOOM_IN]`, `[SLOW_ZOOM_OUT]` |
| Fast zoom | `[FAST_ZOOM_IN]`, `[FAST_ZOOM_OUT]` |
| Pan | `[PAN_LEFT]`, `[PAN_RIGHT]` |
| Tilt | `[TILT_UP]`, `[TILT_DOWN]` |
| Dolly | `[DOLLY_IN]`, `[DOLLY_OUT]` |
| Tracking | `[TRACKING_LEFT]`, `[TRACKING_RIGHT]` |
| Crane | `[CRANE_UP]`, `[CRANE_DOWN]` |
| Other | `[ORBIT]`, `[HANDHELD]`, `[ROLL]` |

**How it works**: when you select a tag, it's injected both at the start of the prompt and as a `FINAL CAMERA DIRECTIVE` at the end — so Qwen 9B actually respects it despite recency bias on long prompts. The tag also gets a short description so Qwen knows exactly what to write.

**Subject stays alive**: the directive explicitly tells Qwen that the camera tag controls ONLY the camera — the subject must still have natural, lively action (breathing, gestures, expression, body motion) throughout the clip. No more "statue during orbit" problem.

**Manual tags still work**: if you leave the dropdown on `None` and type `[ORBIT]` in your prompt, it's detected and injected automatically as a fallback.

Available on all three QwenVL nodes: `AILab_QwenVL`, `AILab_QwenVL_Advanced`, and `AILab_QwenVL_PromptEnhancer`.

### 🔄 FL2VA Loop Merged into FL2VA — One Workflow, Bypass Group

The loop trim logic now lives inside the main FL2VA workflow, wrapped in a **"Loop Trim" group** that can be toggled via the rgthree **Fast Groups Bypasser** node:

- **Loop mode (trim active)**: the `ImageFromBatch` + `ComfyMathExpression` nodes trim the frozen tail (~5 frames) for seamless looping
- **Non-loop mode (trim bypassed)**: toggle the group off in the Bypasser → VAEDecode passes directly to RIFE/upscale, full frames preserved

No more switching between two workflows — just toggle the group.

### 🧹 PromptEnhancer Cleanup

- Removed the redundant `custom_system_prompt` input — `enhancement_style` (presets) + `prompt_text` (user input) cover all use cases
- Removed `CUSTOM_ONLY_STYLE` ("✍️ Custom Only (no preset)") — no longer needed
- Added `camera_tag` dropdown (same as main QwenVL nodes)

### 📦 Workflow Count

With the loop merged into FL2VA, the pack ships **4 workflows** (T2VA, I2VA, FL2VA, R2VA) plus the combined ALL-WFs zip. All workflows updated with the new `camera_tag` input.

---

## ⬆️ 2026/08/31 UPDATE ⬆️

### 🎲 Wildcards (T2VA Workflow)

The T2VA Turbo workflow includes a **WildcardProcessor** node that injects randomized prompt fragments from the **PMP's Prompt Engine** (`__pmp/prmpt/*`) wildcard library. Each generation picks a random entry from each wildcard file, so the same seed produces different results across runs unless you pin the seed.

**Wildcards Used in the T2VA Workflow**

| Wildcard | Category | What it randomizes |
|---|---|---|
| `__pmp/prmpt/vidstyle__` | Video style | Cinematic / anime / vintage film / 3D CG / claymation / watercolor / fantasy etc. |
| `__pmp/prmpt/imgcmp/shots__` | Camera shot | Close-up / wide / medium / dolly / crane / orbit / handheld etc. |
| `__pmp/prmpt/lctns/rndmlctns__` | Location | Random setting (bedroom / beach / studio / alley / forest / rooftop etc.) |
| `__pmp/prmpt/light/rndmlight__` | Lighting | Key light direction, color temperature, soft/hard, ambient mood |
| `__pmp/prmpt/char/favchar__` | Character | Random character archetype (age, body type, hair, ethnicity) |
| `__pmp/prmpt/clths/rndmclth__` | Clothing | Random outfit / garment description |
| `__pmp/prmpt/clths/nudty_brsts__` | NSFW | Breast / nudity descriptors (NSFW preset) |
| `__pmp/actsolo/brstplng__` | NSFW action | Solo breast-play action verbs (NSFW preset) |

**How It Works**

1. The **WildcardProcessor** node sits before the Qwen3.5 prompt enhancer
2. At queue time, each `__wildcard__` token is replaced with a random line from the corresponding `.txt` file inside `ComfyUI/custom_nodes/ComfyUI-Wildcards/wildcards/pmp/prmpt/`
3. The expanded text is passed to Qwen3.5, which converts it into the official MiniMax H3 prompt format
4. **Different seed = different wildcard picks** — use a fixed seed if you want reproducible results

**Customizing Wildcards**

- **Edit existing**: open the `.txt` files under `ComfyUI/custom_nodes/ComfyUI-Wildcards/wildcards/pmp/prmpt/` and add/remove lines (one entry per line)
- **Add your own**: create a new `.txt` file, e.g. `pmp/prmpt/mytags.txt`, then reference it as `__pmp/prmpt/mytags__`
- **Remove a wildcard**: delete the `__...__` token from the WildcardProcessor `text` field in the workflow
- **Disable randomization**: replace the `__wildcard__` token with a fixed string

**Required Custom Node**

- **ComfyUI-TagForge** (includes the `WildcardProcessor` node and the `__pmp/prmpt/*` wildcard set) — [huchukato/ComfyUI-TagForge](https://github.com/huchukato/ComfyUI-TagForge)

> The wildcard files ship with the custom node. If a wildcard resolves to empty, the custom node is missing or the wildcard folder is not installed.

### 🔄 Sampler Change — MiniMaxH3TurboSampler → KSamplerSelect + MiniMaxH3SigmaShift

All Turbo workflows (T2VA, I2VA, FL2VA, FL2VA-Loop, R2VA) have been updated to use **ComfyUI core nodes** instead of the custom `MiniMaxH3TurboSampler`:

- **Removed**: `MiniMaxH3TurboSampler` (custom node from `Larryvrh/ComfyUI-MiniMax-H3-Turbo`)
- **Added**: `KSamplerSelect` (sampler: `euler`) + `MiniMaxH3SigmaShift` (shift_video=12, shift_audio=3) — both **ComfyUI core nodes**, no custom node required
- **Scheduler**: `simple` (unchanged)

**Why?**

- On ComfyUI v0.35.0+ with native `ModelSamplingAV`, the custom `MiniMaxH3TurboSampler` internally delegates to stock `euler` anyway — the custom node is redundant
- Using core nodes means the **same workflow** works with both:
  - **Standard model** (`minimax_h3_fl2va_pruned_int8_convrot`) + Turbo LoRA `minimax_h3_turbo_v4_step600_ema`
  - **10Eros-Max** (`10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ`) + T8 compatibility LoRA `minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8`
- Just swap `LoadDiffusionModel` and `LoraLoaderBypassModelOnly` — the sampler path stays the same

**10Eros-Max (Optional — Experimental)**

- **Model**: `10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors` (~23.5 GB) — [DmitryDB/MiniMax-H3-10Eros-Max-Quants](https://huggingface.co/DmitryDB/MiniMax-H3-10Eros-Max-Quants/resolve/main/FL2VA/10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors)
- **LoRA**: `minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors` (~1.96 GB) — [t8star/minimax_h3_turbo_4step_10ErosMax_test4_pruned_curveproj1025_T8](https://huggingface.co/t8star/minimax_h3_turbo_4step_10ErosMax_test4_pruned_curveproj1025_T8/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors)
- **Sampler**: `euler` + `MiniMaxH3SigmaShift` (shift 12/4) + `simple` scheduler — same as standard model
- ⚠️ **NVFP4 rimosso** — perdita di qualità; usa solo INT8 ConvRot (`10Eros_Max_h3_hybrid_beta5_int8` + LoRA `lightx2v_hybrid-4to8step`)
- ⚠️ The T8 LoRA is **checkpoint-specific** — only works with the exact 10Eros pruned model (SHA-256: `f82cc3f723b080e7ae94a7c98f95aa989e387618d0bdc940133dfbd9f432c062`)

---

## ⬆️ 2026/08/27 UPDATE ⬆️

### Pure INT8 ConvRot — Default
- Default diffusion models: **pure INT8 ConvRot** (`minimax_h3_fl2va_pruned_int8_convrot` / `minimax_h3_ref2va_pruned_int8_convrot`) from [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) — best quality; NVFP4 was removed due to visible quality loss
- Uncensored text encoder: **NVFP4** (`qwen3vl_32b_heretic_minimax_h3_nvfp4`) from [Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4) — full H3 conditioning, ~15 GB
- Speed comes from turbo LoRA (lightx2v 8-step), sol-attn sparse attention, and the `--enable-triton-backend` comfy-kitchen backend — works on any modern NVIDIA

### SOL-ATTN Integration
- All Turbo workflows include **SOL-ATTN** nodes (sparse attention + fused modulation + chunked FFN)
- Tau per mode: 1.30 su turbo (FL2VA/R2VA/10Eros), 1.00 su native — vedi tabella preset in testa
- Spectrum and DiffAid were removed from the stack — Sol-Attn is the only acceleration patch

### Turbo Step Standardization
- All Turbo workflows standardized to **8 steps** (was 6 for T2VA/R2VA)
- Consistent `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16` LoRA across all workflows

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

- 🟢 **Recommended template configuration** — RTX 5090 (32 GB) / RTX PRO 6000 (48 GB) → INT8 ConvRot diffusion + INT8 Heretic text encoder
- 🟡 **Low-VRAM alternative** — RTX 4090 / 3090 (24 GB) → INT8 ConvRot + offload
- 🟠 **Lower-VRAM alternative** — 12–16 GB → INT4 + aggressive offload; slow and not recommended for production


> **12 GB GPUs (e.g. RTX 3060 12GB)**: Technically possible with INT4 models + aggressive offloading, but **very slow**. You need 32 GB+ system RAM and a fast NVMe SSD. Not recommended for production use.

### Model Quantization Options

- **BF16 (full)** — Diffusion ~42 GB + Text encoder ~65 GB = ~110 GB total → [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **INT8 (pruned)** — Diffusion ~21 GB + Text encoder ~24.5 GB = ~50 GB total → [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- **INT4 (pruned)** — Diffusion ~11 GB + Text encoder ~15 GB = ~24.5 GB total → [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)
- **Pure INT8 ConvRot (recommended — verified)** — Diffusion ~21 GB + uncensored INT8 Heretic text encoder ~26.4 GB = ~47 GB active model set → [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) + [ethanfel/Qwen3-VL-32B-Ultra-Heretic-H3-ComfyUI-INT8-ConvRot](https://huggingface.co/ethanfel/Qwen3-VL-32B-Ultra-Heretic-H3-ComfyUI-INT8-ConvRot). Best quality on any modern NVIDIA

### Software

- **ComfyUI**: current upstream master (required for MiniMax H3 native support)
- **Python**: 3.10+
- **CUDA**: 12.8+ (13.0 recommended)
- **Storage**: allow at least 130 GB for the complete provisioned package (~94 GB of models plus engines, workflows and outputs)

### Qwen3.5 Prompt Enhancer

- **GGUF**: Q4_K_S or Q5_K_S quantization for 4B/9B models
- **HF**: `Qwen3.5-9B-Defiant-Fable-Heretic` (~18 GB) or `Qwen3.5-4B-heretic-v2` (~8 GB)

### ⚡ MiniMax-H3 Turbo LoRA (Optional — Faster & Sharper)

A distilled 8-step LoRA for MiniMax-H3 that replaces the default 28-32 step sampling. All Turbo workflows include the native **BlockSparseAttention** (sol-attn) node — tau 1.30 at 8 steps.

- **Sparse attention**: built into ComfyUI — the native `BlockSparseAttention` node (method `sol-attn`), no custom node required
- **Recommended LoRA**: `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors` (~1.96 GB)
- **Download**: [lightx2v/Minimax-h3-Turbo](https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors)
- **Install**: place the `.safetensors` in `ComfyUI/models/loras/`
- **Usage**: 8 steps with scheduler `simple`, sampler `euler` + `MiniMaxH3SigmaShift` (shift 12/4 FL2VA, 6/4 R2VA). No custom sampler node required — standard LoRA loader works.

Works with all tasks: T2VA, I2VA, FL2VA and R2VA.

---

## ⚙️ Model Configuration Cheat Sheet

All Turbo workflows ship with **bypass groups** for Sol-Attn and Turbo LoRA. Toggle them via the rgthree **Fast Groups Bypasser** node depending on which model you load.

### 📊 Configuration Matrix

| Setting | 10Eros Turbo | lightx2v Turbo LoRA | Native |
|---|---|---|---|
| **Diffusion model** | `10Eros_Max_h3_hybrid_beta5_int8` | `minimax_h3_fl2va_pruned_int8_convrot` | `minimax_h3_fl2va_pruned_int8_convrot` |
| **Turbo LoRA** | ✅ ON `lightx2v_hybrid-4to8step` | ✅ ON (strength 1.0) | ❌ OFF |
| **Steps** | 8 | 8 | 28-32 |
| **Sampler** | `euler` | `euler` | `res_multistep` |
| **Scheduler** | `simple` | `simple` | `simple` |
| **Video shift** | 12 | 12 | 6 |
| **Audio shift** | 4 | 4 | 3 |
| **Sol-Attn** | ✅ ON (tau 1.30) | ✅ ON (tau 1.30) | ✅ ON (tau 1.00) |
| **CK Attention** | ✅ ON (`--enable-triton-backend`) | ✅ ON | ✅ ON |

### 🔧 How to Switch Models in the Workflow

1. **LoadDiffusionModel** — swap the `.safetensors` file
2. **LoraLoaderBypassModelOnly** — toggle bypass:
   - 10Eros / Native → **bypassed** (LoRA off)
   - Turbo LoRA → **active** (strength 1.0)
3. **Sol-Attn node** — set tau (or bypass the group via Fast Groups Bypasser):
   - 10Eros → **tau 1.30**
   - Turbo LoRA → **tau 1.5-2.0** or **bypassed**
   - Native → **tau 1.0**
4. **KSamplerSelect** — change sampler (`euler` for Turbo/10Eros, `res_multistep` for Native)
5. **MiniMaxH3SigmaShift** — shift 12/4 (FL2VA turbo), 6/4 (R2VA turbo), 6/3 (10Eros), 4/3 (R2VA native), 6/3 (native FL2VA)
6. **Sampler steps** — 8 turbo, 28-32 native, 30-40 10Eros

### 🚀 10Eros-Max TURBO Hybrid (Recommended for Turbo)

- **Model**: `10Eros_Max_h3_hybrid_beta5_int8.safetensors` (~20 GB) — [TenStrip/10Eros-Max](https://huggingface.co/TenStrip/10Eros-Max)
- **Non-turbo checkpoint**: per la modalità turbo applicare il LoRA `lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned` (strength 1.0)
- **Sol-Attn ON** — tau 1.30 per il preset 10Eros turbo
- 10Eros Beta5 è **non-turbo**: per la modalità turbo applicare il LoRA `lightx2v_hybrid-4to8step` (strength 1.0)

### ⚡ lightx2v Turbo LoRA (Standard Turbo)

- **LoRA**: `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors` (~1.96 GB) — [lightx2v/Minimax-h3-Turbo](https://huggingface.co/lightx2v/Minimax-h3-Turbo)
- **Ref2VA LoRA**: `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors` (~1.96 GB) — Comfy-Org
- Trained at 1344×768 — matches native resolution
- **Sol-Attn**: tau 1.5-2.0, or OFF for max safety (tau 1.0 causes fallbacks at 8 steps)
- No custom node required — standard LoRA loader works

### 🎬 Native (Maximum Quality)

- **Model**: standard pure INT8 ConvRot (`minimax_h3_fl2va_pruned_int8_convrot`)
- **No Turbo LoRA** — full 28-32 step sampling
- **Sol-Attn ON** (tau 1.00) — safe on the native trajectory
- Sampler: `res_multistep` (not `euler`)
- Shift: 6/3 (FL2VA native), 4/3 (R2VA native con `ref_lora_rank_256`)
- Slower but highest visual quality

---

## 🌟 What is ComfyUI-QwenVL-Mod?

A powerful enhanced vision-language node for ComfyUI that combines **Qwen3.5** models with **MiniMax H3** video generation workflows. Features multilingual support, visual style detection, native stereo audio, and NSFW capabilities for professional AI content creation.

Think: *"Your all-in-one solution for intelligent prompt enhancement and video+audio generation with MiniMax H3!"*

---

## 🎬 Key Features

### 🚀 MiniMax H3 Video+Audio Generation

- **T2VA** (Text-to-Video+Audio): Generate video with native stereo audio from text
- **I2VA** (Image-to-Video+Audio): Animate a first-frame image with audio
- **FL2VA** (First-Last-Frame): Generate the transition between two keyframes — Qwen3.5 sees both frames
- **R2VA** (Reference-to-Video): Lock character identity, style, motion, or voice using reference images

### 🧠 Qwen3.5 Auto-Prompting

- **Multilingual**: Write your prompt in **any language** — Qwen3.5 translates and converts it
- **Auto-format**: Generates the official MiniMax H3 prompt format (3-field for base, 6-field for R2VA)
- **Multi-reference**: Qwen3.5 analyzes the two images connected through `image` + `image2`; additional MiniMax references can be described with `[P3]` / `[P4]` tags
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

## 📦 What's Included — 8 Workflows

All workflows are pre-wired with `lightx2v Turbo LoRA` at **8 steps** + SOL-ATTN (tau per mode — see the configuration matrix). The Singularity and Director workflows bake their own recipes (see the preset table).

### 📥 Download

| File | Contents | Link |
|---|---|---|
| `MiniMaxH3-Turbo-Qwen3.5-ALL-WFs.zip` | All 5 workflows (T2VA + I2VA + FL2VA + FL2VA-Loop + R2VA) | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-Qwen3.5-ALL-WFs.zip) |
| `MiniMaxH3-Turbo-T2VA-Qwen3.5.zip` | T2VA only | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-T2VA-Qwen3.5.zip) |
| `MiniMaxH3-Turbo-I2VA-Qwen3.5.zip` | I2VA only | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-I2VA-Qwen3.5.zip) |
| `MiniMaxH3-Turbo-FL2VA-Qwen3.5.zip` | FL2VA only (includes bypassable loop trim) | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-FL2VA-Qwen3.5.zip) |
| `MiniMaxH3-Turbo-FL2VA-Loop-Qwen3.5.zip` | FL2VA Loop only (seamless looping) | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-FL2VA-Loop-Qwen3.5.zip) |
| `MiniMaxH3-Turbo-R2VA-Qwen3.5.zip` | R2VA only | [Download](https://github.com/huchukato/ComfyUI-Garage/releases/download/minimax-h3-wf-v2.8.1/MiniMaxH3-Turbo-R2VA-Qwen3.5.zip) |

> Individual `.json` files also available in [`workflows/minimax/`](https://github.com/huchukato/ComfyUI-Garage/tree/master/workflows/minimax).

### Workflows

1. ⚡ **T2VA Turbo** — `MiniMaxH3-Turbo-T2VA-Qwen3.5.json` — text only — Text-to-video+audio. Simplest workflow.
2. ⚡ **I2VA Turbo** — `MiniMaxH3-Turbo-I2VA-Qwen3.5.json` — text + first-frame image (`image`) — Image-to-video. First-frame animation with audio.
3. ⚡ **FL2VA Turbo** — `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` — text + first-frame (`image`) + last-frame (`image2`) — First-Last-Frame to video. Includes TensorRT upscale + RIFE frame interpolation for 48 fps output. **Loop trim is built in** — toggle the "Loop Trim" group via the Fast Groups Bypasser node for seamless loops.
4. ⚡ **R2VA Turbo** — `MiniMaxH3-Turbo-R2VA-Qwen3.5.json` — text + reference images (`image` + `image2`) — Reference-to-video. Lock identity, style, motion, camera, or voice using up to 9 ref images.
5. ⚡ **Singularity R2VA** ⭐ — `MiniMaxH3-Singularity-R2VA-Qwen3.5.json` — reference-to-video on the **fused Singularity checkpoint** (T2V/I2V/R2V/V2V in one unet, no rank-256 LoRA). Turbo recipe baked: `euler` + `beta` + 6 steps + ref2v turbo LoRA.
6. 🎬 **Director Native** ⭐ — `MiniMaxH3-Director-Native-Qwen3.5.json` — charsheet + ideas one per line → the Director compiles the multi-segment timeline (auto-Analyze + per-segment Enhance). Singularity Turbo baked, `config` dropdown, refs switch, style dropdown.
7. 🎬 **Director Storyboard** ⭐ — `MiniMaxH3-Director-Storyboard-Qwen3.5.json` — up to 3 scene stills (from `QwenImageEdit21`, preset `IMG › Storyboard`) → in-graph QwenVL writes the final R2VA prompt → Director renders with the stills as references. Singularity Turbo baked.

> FL2VA and R2VA include **TensorRT upscaling** and **RIFE frame interpolation** for 48 fps high-resolution output.

---

## 🖼️ Multi-Reference Input (image2)

The QwenVL-Mod node has two image inputs:

- **T2VA**: no images needed
- **I2VA**: `image` = first frame
- **FL2VA**: `image` = first frame, `image2` = last frame, `frame_count` = 1
- **R2VA**: `image` = primary reference, `image2` = additional references (batch, up to 9), `frame_count` = 1–9

> Qwen3.5 sees **all** connected images as individual images (not as a video sequence), enabling proper multi-reference analysis for FL2VA and R2VA.

---

## 🎯 QwenVL-Mod NSFW Presets (9 total)

The workflows include built-in NSFW presets for the Qwen3.5 prompt enhancer:

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
- All presets: support **camera control tags** (`[STATIC_CAMERA]`, `[SLOW_ZOOM_IN]`, `[SLOW_ZOOM_OUT]`, `[ORBIT]`, `[HANDHELD]`) — see [Camera Control Tags](#-camera-control-tags) below
- FL2VA presets: automatic **loop mode** when first and last frame are the same image — see [Loop Mode](#-loop-mode-fl2va-only) below

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
- **Comfy Kitchen Attention** (`--enable-triton-backend`): triton backend, FP16 accumulation
- **Smart caching**: Reuse prompts with same inputs, Fixed Seed Mode for text-only caching

### 🎨 Model Support

- **Qwen3.5**: 4B / 9B / 27B (uncensored, heretic, unsloth) — thinking mode disabled
- **Qwen3.8**: latest-generation models (GGUF + HF)
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

- **ComfyUI-QwenVL-Mod** — All workflows (Qwen3.5 prompt enhancer) — [huchukato/ComfyUI-QwenVL-Mod](https://github.com/huchukato/ComfyUI-QwenVL-Mod)
- **Block Sparse Attention** — Turbo workflows use the native ComfyUI node (built-in, no install needed)
- **ComfyUI-RIFE-TensorRT-Auto** — FL2VA, R2VA (frame interpolation) — [huchukato/ComfyUI-RIFE-TensorRT-Auto](https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto)
- **ComfyUI-Upscaler-TensorRT-Auto** — FL2VA, R2VA (upscaling) — [huchukato/ComfyUI-Upscaler-TensorRT-Auto](https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto)
- **ComfyUI-VideoHelperSuite** — FL2VA, R2VA (VHS_VideoCombine) — [Kosinkadink/ComfyUI-VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- **ComfyUI-Easy-Use** — FL2VA, R2VA (easy showAnything) — [yolain/ComfyUI-Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use)
- **ComfyUI-PerfectVideoResolution** — All workflows (resolution calculator) — [huchukato/ComfyUI-PerfectVideoResolution](https://github.com/huchukato/ComfyUI-PerfectVideoResolution)

> **Note**: `ComfyMathExpression` is built into ComfyUI core (v0.24.1+) — no custom node needed.

### Models Required

**T2VA / I2VA / FL2VA** use the INT8 **FL2VA** model:

- `models/vae/` → `minimax_h3_video_vae_fp16.safetensors` (~5 GB)
- `models/vae/` → `minimax_h3_audio_vae_fp32.safetensors` (~0.6 GB)
- `models/diffusion_models/` → `minimax_h3_fl2va_pruned_int8_convrot.safetensors` (~20 GB) — [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)
- `models/text_encoders/` → `qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors` (~15 GB) — [Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4)

**R2VA (ref2va)** uses the INT8 Ref2VA model:

- `models/diffusion_models/` → `minimax_h3_ref2va_pruned_int8_convrot.safetensors` (~20 GB) — [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3)

> INT8 ConvRot runs on any modern NVIDIA GPU — no Blackwell requirement.

**10Eros-Max INT8 (optional/experimental)**

- `models/diffusion_models/` → `10Eros_Max_H3_FL2VA-INT8-ConvRot-HQ.safetensors` (~23.5 GB)
- Pair it only with `minimax_h3_fl2v_turbo_8step_v1.0_10ErosMax_beta1_pruned_compat_v001_T8.safetensors` (~1.96 GB)
- Switch both diffusion model and matching LoRA together; do not mix the standard and 10Eros LoRAs
- The standard MiniMax H3 pure INT8 ConvRot is the verified default. 10Eros-Max (`10Eros_Max_h3_hybrid_beta5_int8`) remains experimental — non-turbo checkpoint, apply the `lightx2v_hybrid-4to8step` LoRA for turbo mode

**Turbo LoRA (standard — all tasks)**

- `models/loras/` → `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors` (~1.96 GB)
- `models/loras/` → `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors` (~1.96 GB)
- No custom node required — standard LoRA loader works

**INT4 alternative** (for 12-16 GB GPUs): [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)

**Qwen Prompt Enhancer**

- `models/LLM/` → `Qwen3.5-9B-Defiant-Fable-Heretic` or `Qwen3.5-4B-heretic-v2` (GGUF or HF)

**TensorRT Engines (FL2VA + R2VA only)**

- `models/upscale_models/` → `RealESRGAN_x4` (TensorRT engine)
- `models/rife/` → `rife425_ensemble_False_scale_1_sim` (TensorRT engine, ONNX auto-downloaded from HF)

> TensorRT engines must be built for your specific GPU. See [ComfyUI-RIFE-TensorRT-Auto](https://github.com/huchukato/ComfyUI-RIFE-TensorRT-Auto) and [ComfyUI-Upscaler-TensorRT-Auto](https://github.com/huchukato/ComfyUI-Upscaler-TensorRT-Auto) for build instructions.

### Download Links

- **VAE**: [video_vae_fp16](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors) · [audio_vae_fp32](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors)
- **Diffusion (fl2va, INT8 ConvRot)**: [minimax_h3_fl2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/minimax_h3_fl2va_pruned_int8_convrot.safetensors)
- **Diffusion (ref2va, INT8 ConvRot)**: [minimax_h3_ref2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/minimax_h3_ref2va_pruned_int8_convrot.safetensors)
- **Diffusion (fl2va, INT8 — Comfy-Org path)**: [minimax_h3_fl2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors)
- **Diffusion (ref2va, INT8 — Comfy-Org path)**: [minimax_h3_ref2va_pruned_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors)
- **Text encoder (uncensored, NVFP4)**: [qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors](https://huggingface.co/Momoking/Qwen3-VL-32B-Heretic-MiniMax-H3-NVFP4/resolve/main/qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors)
- **Text encoder (official, INT8 alternative)**: [qwen3vl_32b_minimax_h3_int8_convrot.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_int8_convrot.safetensors)
- **Turbo LoRA (standard, FL2VA)**: [minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors](https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16.safetensors)
- **Turbo LoRA (standard, Ref2VA)**: [minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors)
- **10Eros-Max diffusion (optional/experimental, INT8)**: [10Eros_Max_h3_hybrid_beta5_int8.safetensors](https://huggingface.co/TenStrip/10Eros-Max/resolve/main/10Eros_Max_h3_hybrid_beta5_int8.safetensors) + LoRA [lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned](https://huggingface.co/TenStrip/MinimaxH3-Turbo_Shenanigans/resolve/main/lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned.safetensors)
- **INT4 models**: [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)

---

## 🎬 MiniMax H3 Prompting Notes

### How to Write Your Prompt

Describe the scene naturally. Be clear about the concepts below — Qwen3.5 handles the rest:

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

### 🎥 Camera Control Tags

All MiniMax H3 NSFW presets support camera control via the **`camera_tag` dropdown** on the QwenVL node — no need to type tags manually. Select from 19 camera movements:

| Tag | Effect |
|---|---|
| `[STATIC_CAMERA]` / `[LOCKED_OFF]` | Camera completely static — no zoom, pan, orbit, or any motion |
| `[SLOW_ZOOM_IN]` | Slow continuous push-in (dolly toward subject) |
| `[SLOW_ZOOM_OUT]` | Slow continuous pull-back (dolly away from subject) |
| `[FAST_ZOOM_IN]` | Fast aggressive push-in, dramatic |
| `[FAST_ZOOM_OUT]` | Fast pull-back, reveal context |
| `[PAN_LEFT]` | Smooth horizontal pan from right to left |
| `[PAN_RIGHT]` | Smooth horizontal pan from left to right |
| `[TILT_UP]` | Smooth vertical tilt from bottom to top, revealing the subject |
| `[TILT_DOWN]` | Smooth vertical tilt from top to bottom |
| `[DOLLY_IN]` | Physical dolly movement toward the subject (parallax, not optical zoom) |
| `[DOLLY_OUT]` | Physical dolly movement away from the subject (parallax) |
| `[TRACKING_LEFT]` | Lateral tracking shot moving left, subject stays in frame |
| `[TRACKING_RIGHT]` | Lateral tracking shot moving right, subject stays in frame |
| `[CRANE_UP]` | Crane/jib movement rising upward, revealing the scene from above |
| `[CRANE_DOWN]` | Crane/jib movement descending toward the subject |
| `[ORBIT]` | Smooth 360-degree orbit around the subject |
| `[HANDHELD]` | Subtle handheld sway with natural micro-movements |
| `[ROLL]` | Slow camera roll (rotation around the lens axis) |

**How it works**: the selected tag is injected at the start of the prompt AND as a `FINAL CAMERA DIRECTIVE` at the end, so Qwen respects it despite recency bias on long prompts. The subject stays alive and active — the tag controls only the camera.

If the dropdown is set to `None`, Qwen3.5 chooses a natural camera movement automatically. You can also type tags manually in your prompt as a fallback.

**Example:**
```
Dropdown: [ORBIT]
Prompt: she continues a slow rhythmic motion, breathing steadily
```

### 🔄 Loop Mode (FL2VA Only)

The FL2VA presets include automatic **loop mode** detection. When you load the **same image** as both first frame (`image`) and last frame (`image2`), the preset detects the identical endpoints and generates a seamless cyclic action:

- The motion starts immediately from frame 0 (no wind-up or preparation)
- The action continues at a steady rhythm for the entire duration (no early freeze)
- The final state matches the first frame exactly (pose, framing, expression)
- For repetitive actions (oral, stroking, thrusting, grinding): the rhythm continues without interruption, with natural variations in pace, depth, and angle
- The word "loop" or "repeat" is never used in the generated prompt — the cyclicity is implicit
- Camera motion in loop mode uses continuous circular or oscillating movements that return to the starting position (combine with `[STATIC_CAMERA]` if you want a locked-off loop)

**To use loop mode:**
1. Load `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` (the main FL2VA workflow — loop is built in)
2. Upload the **same image** to both `image` (first frame) and `image2` (last frame)
3. Select preset `🔄 MiniMax H3 NSFW FL2VA (5s/10s/15s)`
4. Describe the action — the preset handles the cyclic structure automatically
5. (Optional) Set `camera_tag` to `[STATIC_CAMERA]` if you want no camera movement

**Loop Trim Bypass Group**: the FL2VA workflow includes a **"Loop Trim" group** (wrapped around `ImageFromBatch` + `ComfyMathExpression`) controlled by the rgthree **Fast Groups Bypasser** node:

- **Group ACTIVE (default)** → trim removes the frozen tail (~5 frames) for seamless looping
- **Group BYPASSED** → full frames preserved, VAEDecode passes directly to RIFE/upscale (non-loop use)

> ✂️ **Automatic trim**: The trim removes the last 5 frames (0.2s at 24fps) — the frozen tail that MiniMax H3 adds at the end of FL2VA generation. The `ComfyMathExpression` node calculates the trim length automatically from the duration:
> - 5s → `119` (124 - 5)
> - 10s → `238` (243 - 5)
> - 15s → `357` (362 - 5)

> ⚠️ **Limitations**: The automatic trim removes the frozen tail but minor discontinuity at the cut point may still occur due to velocity or camera phase differences. For a pixel-perfect loop, crossfade the last 0.5s with the first 0.5s in post-production.

---

## 🎲 Wildcards (T2VA Workflow)

The T2VA Turbo workflow includes a **WildcardProcessor** node that injects randomized prompt fragments from the **PMP's Prompt Engine** (`__pmp/prmpt/*`) wildcard library. Each generation picks a random entry from each wildcard file, so the same seed produces different results across runs unless you pin the seed.

### Wildcards Used in the T2VA Workflow

| Wildcard | Category | What it randomizes |
|---|---|---|
| `__pmp/prmpt/vidstyle__` | Video style | Cinematic / anime / vintage film / 3D CG / claymation / watercolor / fantasy etc. |
| `__pmp/prmpt/imgcmp/shots__` | Camera shot | Close-up / wide / medium / dolly / crane / orbit / handheld etc. |
| `__pmp/prmpt/lctns/rndmlctns__` | Location | Random setting (bedroom / beach / studio / alley / forest / rooftop etc.) |
| `__pmp/prmpt/light/rndmlight__` | Lighting | Key light direction, color temperature, soft/hard, ambient mood |
| `__pmp/prmpt/char/favchar__` | Character | Random character archetype (age, body type, hair, ethnicity) |
| `__pmp/prmpt/clths/rndmclth__` | Clothing | Random outfit / garment description |
| `__pmp/prmpt/clths/nudty_brsts__` | NSFW | Breast / nudity descriptors (NSFW preset) |
| `__pmp/actsolo/brstplng__` | NSFW action | Solo breast-play action verbs (NSFW preset) |

### How It Works

1. The **WildcardProcessor** node sits before the Qwen3.5 prompt enhancer
2. At queue time, each `__wildcard__` token is replaced with a random line from the corresponding `.txt` file inside `ComfyUI/custom_nodes/ComfyUI-Wildcards/wildcards/pmp/prmpt/`
3. The expanded text is passed to Qwen3.5, which converts it into the official MiniMax H3 prompt format
4. **Different seed = different wildcard picks** — use a fixed seed if you want reproducible results

### Customizing Wildcards

- **Edit existing**: open the `.txt` files under `ComfyUI/custom_nodes/ComfyUI-Wildcards/wildcards/pmp/prmpt/` and add/remove lines (one entry per line)
- **Add your own**: create a new `.txt` file, e.g. `pmp/prmpt/mytags.txt`, then reference it as `__pmp/prmpt/mytags__`
- **Remove a wildcard**: delete the `__...__` token from the WildcardProcessor `text` field in the workflow
- **Disable randomization**: replace the `__wildcard__` token with a fixed string

### Required Custom Node

- **ComfyUI-TagForge** (includes the `WildcardProcessor` node and the `__pmp/prmpt/*` wildcard set) — [huchukato/ComfyUI-TagForge](https://github.com/huchukato/ComfyUI-TagForge)

> The wildcard files ship with the custom node. If a wildcard resolves to empty, the custom node is missing or the wildcard folder is not installed.

---

## 🐳 Docker / Cloud Ready

### OneClick RunPod Template

Prefer a ready-to-go environment? Use the **OneClick - ComfyUI - MiniMax H3 Turbo - Qwen3VL** RunPod template:

- **Docker image**: `huchukato/comfyui-qwenvl-runpod:cu13-mmh3`
- **Base**: `huchukato/comfyui-base:cu130`
- All custom nodes pre-installed
- **ComfyUI Args**: `--highvram --disable-auto-launch --fast fp16_accumulation --enable-triton-backend --force-fp16`
- All 5 Turbo workflows auto-downloaded at boot
- Models auto-downloaded at first boot (~96 GB including INT8 diffusion, INT8 Heretic text encoder, 10Eros INT8 and turbo/reference LoRAs; persistent)
- ComfyUI tracks the current upstream `master` branch by default
- Comfy Kitchen Attention, FP16 accumulation, high-VRAM mode
- TensorRT upscaling + RIFE interpolation (stable defaults: Upscaler `2/2`, RIFE `1/1`)
- SOL-ATTN acceleration active in all modes (tau 1.30 turbo, 1.00 native)

> **Access**: ComfyUI `:8188` · JupyterLab `:8888` · FileBrowser `:8080` (user `admin` / password `adminadmin12`) · SSH `ssh root@pod-ip`

[📖 README & instructions](https://github.com/huchukato/ComfyUI-QwenVL-Mod/blob/main/runpod/README_MiniMaxH3.md)

### ComfyUI Args (pre-configured)

```
--highvram
--disable-auto-launch
--fast fp16_accumulation
--enable-triton-backend
--force-fp16
```

---

## 🚀 Why Choose ComfyUI-QwenVL-Mod + MiniMax H3?

### 🎬 For Content Creators
- **Native audio**: Video and audio in one pass — no separate MMAudio needed
- **Multilingual**: Write in any language, Qwen3.5 handles translation
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
- **Extendable**: Add your own Qwen3.5 models (GGUF or HF)
- **Integrable**: Works with existing ComfyUI setups
- **Optimized**: Comfy Kitchen Attention, FP16 accumulation, high-VRAM mode, smart caching
- **Multi-reference**: `image2` input for FL2VA and R2VA workflows

---

## 🌟 What Makes This Special?

- **First**: Complete MiniMax H3 workflow pack with Qwen3.5 auto-prompting
- **Native audio**: No separate audio node — MiniMax H3 does it all
- **4 Turbo workflows**: T2VA, I2VA, FL2VA, R2VA — covers all MiniMax H3 modes
- **Multi-reference**: Qwen3.5 analyzes the first two connected reference images; additional MiniMax references can be described with `[P3]` / `[P4]` tags
- **TensorRT**: Built-in upscaling and frame interpolation
- **9 NSFW presets**: Dedicated presets for each mode with correct prompt structure
- **Multilingual**: Any input language, auto-translated and formatted
- **Ready**: Works out-of-the-box with included workflows

---

## 🎯 What's New in v2.6.0

### ⚡ Pure INT8 ConvRot — Default
- ✅ Default diffusion models: **pure INT8 ConvRot** (`minimax_h3_fl2va_pruned_int8_convrot` / `minimax_h3_ref2va_pruned_int8_convrot`) from Comfy-Org
- ✅ NVFP4 removed — visible quality loss; speed via turbo LoRA + sol-attn + triton backend
- ✅ Runs on any modern NVIDIA GPU
- ✅ Text encoder: uncensored Heretic INT8 ConvRot (~26.4 GB)

### 🔧 SOL-ATTN Integration
- ✅ All Turbo workflows include **SOL-ATTN** nodes (sparse attention + fused modulation + chunked FFN)
- ✅ Tau per mode: 1.30 turbo, 1.00 native
- ✅ Spectrum and DiffAid removed from the stack (see 2026/09/16 update)
- ✅ Turbo LoRA linked from preset to subgraph in all workflows

### ⚡ Turbo Step Standardization
- ✅ All Turbo workflows standardized to **8 steps** (was 6 for T2VA/R2VA)
- ✅ Consistent `minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16` LoRA across all workflows

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
- **Qwen3.5** — [Qwen Team / Alibaba](https://github.com/QwenLM/Qwen3.5)
- **INT4 models** — [Merserk/MiniMax-H3-INT4-ConvRot](https://huggingface.co/Merserk/MiniMax-H3-INT4-ConvRot)
- **TensorRT RIFE / Upscaler** — [huchukato](https://github.com/huchukato)
- **Block Sparse Attention** — ComfyUI core
- **VideoHelperSuite** — [Kosinkadink](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)
- **Easy-Use** — [yolain](https://github.com/yolain/ComfyUI-Easy-Use)
- **PerfectVideoResolution** — [huchukato](https://github.com/huchukato/ComfyUI-PerfectVideoResolution)

---

## 📄 License

Workflows are released under the same license as the underlying models and custom nodes. See each repository for details.

MiniMax H3 model weights: [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) — MiniMax H3 Community License.

---

Built with ❤️ for the ComfyUI community
