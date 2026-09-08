# MiniMax H3 Acceleration Combinations

## Configurations

| Config | Model | Turbo LoRA | Spectrum | Sol-Attn | CK Attention | Sampler | Steps | Shift (V/A) | Notes |
|--------|-------|-----------|----------|----------|--------------|---------|-------|-------------|-------|
| **A — 10Eros TURBO** | `10Eros_Max_h3_TURBO-hybrid_beta3_int8_convrot_skip_edges` | OFF (fused) | OFF | ON (tau 1.3→0.8) | ON (arg) | `euler` + `simple` | 8 | 6/3 | TURBO fused in checkpoint, Sol-Attn verified working |
| **B — Turbo LoRA pure** | `minimax_h3_fl2va_pruned_nvfp4_convrot_int8` | ON (strength 1.0) | OFF | OFF | ON (arg) | `euler` + `simple` | 8 | 6/3 | lightx2v 8-step 768p, max speed |
| **C — Turbo LoRA + Sol** | `minimax_h3_fl2va_pruned_nvfp4_convrot_int8` | ON (strength 1.0) | OFF | ON (tau 1.5-2.0) | ON (arg) | `euler` + `simple` | 8 | 6/3 | Conservative Sol-Attn, marginal gain |
| **D — Native + Spectrum** | `minimax_h3_fl2va_pruned_nvfp4_convrot_int8` | OFF | ON | ON (tau 1.0) | ON (arg) | `res_multistep` + `simple` | 20 | 12/3 | Max quality, Spectrum cuts ~45% |
| **E — Native pure** | `minimax_h3_fl2va_pruned_nvfp4_convrot_int8` | OFF | OFF | ON (tau 1.0) | ON (arg) | `res_multistep` + `simple` | 20 | 12/3 | Quality reference, slowest |

## Rules

- **10Eros + Turbo LoRA = forbidden**: TURBO is already fused in the 10Eros checkpoint — do NOT stack the lightx2v LoRA on top
- **Spectrum + Turbo/10Eros = forbidden**: continuous fallbacks, slowdown, quality degradation at 8 steps
- **DiffAid + Spectrum + Sol-Attn = interference**: tested combo produced only noise/interference video — avoid stacking all three
- **DiffAid alone**: experimental, no confirmed benefit yet. Keep disabled unless isolated A/B test shows improvement
- **Sol-Attn with Turbo LoRA**: high tau (1.5-2.0) or OFF. tau=1.0 on 8 steps causes fallbacks
- **Sol-Attn with 10Eros**: tau 1.3→0.8 scheduled — verified working well (community tested)
- **Sol-Attn with Native**: tau=1.0 default, safe
- **CK Attention**: always ON via arg, orthogonal to everything
- **Spectrum**: only with 20-step native, needs enough steps to forecast
- **Spectrum mutual exclusivity**: `selective_rollback_correction` and `offline_smoothing_replay` are mutually exclusive — keep `selective_rollback_correction: false`, `offline_smoothing_replay: true`
- **Test one patch at a time**: never enable multiple new acceleration patches simultaneously — isolate each to identify regressions

## Sol-Attn tau reference

| Tau | Behavior | Use case |
|-----|----------|----------|
| 1.0 | ~30% blocks approximated | Native 20-step |
| 1.3→0.8 (scheduled) | tau schedule, linear curve | 10Eros TURBO 8-step |
| 1.5 | ~20% blocks approximated | Turbo LoRA 8-step (conservative) |
| 2.0 | ~10% blocks approximated | Turbo LoRA, max safety |
| OFF | no approximation | Debug or comparison |

## Shift reference

| Mode | Video shift | Audio shift | Notes |
|------|------------|------------|-------|
| Turbo LoRA 768p | 6 | 3 | LightX2V Studio recommended, unlocks motion |
| 10Eros TURBO | 6 | 3 | Same as Turbo LoRA |
| Native 20-step | 12 | 3 | Higher video shift for native trajectory |

## Expected performance (RTX PRO 6000 Blackwell, 1344x768, NVFP4+INT8)

| Workflow | Config | Estimated time / 5s video |
|----------|--------|---------------------------|
| `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` | A (10Eros TURBO) | ~2-3 min |
| `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` | B (Turbo LoRA pure) | ~2-3 min |
| Native (to create) | D (Native + Spectrum) | ~5-7 min |

## Stack summary

| Component | Level | 10Eros TURBO | Turbo LoRA | Native 20-step |
|-----------|-------|-------------|------------|----------------|
| CK Attention | attention kernel (arg) | ON | ON | ON |
| Sol-Attn | sparse attention (node) | ON tau 1.3→0.8 | OFF or tau 1.5+ | ON tau 1.0 |
| Sol-Fusion | fused norm/RoPE (node) | ON (50 blocks) | ON (50 blocks) | ON (50 blocks) |
| Sol-FFN | chunked MLP (node) | ON (52 MLPs, 2 chunks) | ON (52 MLPs, 2 chunks) | ON (52 MLPs, 2 chunks) |
| Spectrum | scheduler forecasting (node) | OFF (bypass) | OFF (bypass) | ON |
| DiffAid | sparse block skip (node) | experimental | experimental | experimental |
| Turbo LoRA | few-step distillation (node) | OFF (fused in model) | ON lightx2v 8-step | OFF (bypass) |
| `--fast fp16_accumulation` | arg | ON | ON | ON |
| `--cuda-malloc` | arg | ON | ON | ON |
| `--async-offload` | arg | ON | ON | ON |
| `--use-ck-attention` | arg | ON | ON | ON |

## How to switch models in the workflow

1. **LoadDiffusionModel** — swap the `.safetensors` file
2. **LoraLoaderBypassModelOnly** — toggle bypass:
   - 10Eros / Native → **bypassed** (LoRA off)
   - Turbo LoRA → **active** (strength 1.0)
3. **Fast Groups Bypasser** — toggle Spectrum and Sol-Attn groups:
   - 10Eros → Sol-Attn **active**, Spectrum **bypassed**
   - Turbo LoRA → both **bypassed**
   - Native → both **active**
4. **KSamplerSelect** — change sampler (`euler` for Turbo/10Eros, `res_multistep` for Native)
5. **MiniMaxH3SigmaShift** — change shift (6/3 for Turbo/10Eros, 12/3 for Native)
6. **Sampler steps** — 8 for Turbo/10Eros, 20 for Native
