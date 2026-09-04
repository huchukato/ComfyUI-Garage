# MiniMax H3 Acceleration Combinations

## Configurations

| Config | Turbo LoRA | Spectrum | Sol-Attn | CK Attention | Sampler | Steps | Notes |
|--------|-----------|----------|----------|--------------|---------|-------|-------|
| **A — Turbo pure** | ON | OFF | OFF | ON (arg) | `euler` + `simple` | 8 | Max speed, acceptable quality |
| **B — Turbo + Sol** | ON | OFF | ON (tau 1.5-2.0) | ON (arg) | `euler` + `simple` | 8 | Conservative Sol-Attn, marginal gain |
| **C — Native + Spectrum** | OFF | ON | ON (tau 1.0) | ON (arg) | `res_multistep` + `simple` | 20 | Max quality, Spectrum cuts ~45% |
| **D — Native pure** | OFF | OFF | ON (tau 1.0) | ON (arg) | `res_multistep` + `simple` | 20 | Quality reference, slowest |

## Rules

- **Spectrum + Turbo = forbidden**: continuous fallbacks, slowdown, quality degradation
- **Sol-Attn with Turbo**: high tau (1.5-2.0) or OFF. tau=1.0 on 8 steps causes fallbacks
- **Sol-Attn with Native**: tau=1.0 default, safe
- **CK Attention**: always ON via arg, orthogonal to everything
- **Spectrum**: only with 20-step native, needs enough steps to forecast

## Sol-Attn tau reference

| Tau | Behavior | Use case |
|-----|----------|----------|
| 1.0 | ~30% blocks approximated | Native 20-step |
| 1.5 | ~20% blocks approximated | Turbo 8-step (conservative) |
| 2.0 | ~10% blocks approximated | Turbo, max safety |
| OFF | no approximation | Debug or comparison |

## Expected performance (RTX 5090, 1344x768, NVFP4+INT8)

| Workflow | Config | Estimated time / 5s video |
|----------|--------|---------------------------|
| `MiniMaxH3-Turbo-FL2VA-Qwen3.5.json` | A (Turbo pure) | ~2-3 min |
| Native (to create) | C (Native + Spectrum) | ~5-7 min |

## Stack summary

| Component | Level | Turbo ON | Native 20-step |
|-----------|-------|----------|----------------|
| CK Attention | attention kernel (arg) | ON | ON |
| Sol-Attn | sparse attention (node) | OFF or tau 1.5+ | ON tau 1.0 |
| Spectrum | scheduler forecasting (node) | OFF (bypass) | ON |
| Turbo LoRA | few-step distillation (node) | ON lightx2v 8-step | OFF (bypass) |
| `--fast fp16_accumulation` | arg | ON | ON |
| `--cuda-malloc` | arg | ON | ON |
| `--async-offload` | arg | ON | ON |
