# MiniMax H3 — Accelerazione: preset e parametri

## Catena modello (ordine corretto nel subgraph)

`Load Diffusion Model (INT8)` → `LoraLoader` → `ModelAttentionBackend` (comfy kitchen attention) → `BlockSparseAttention` (sol-attn, tau) → `MiniMaxH3SigmaShift` (shift V/A) → `BasicGuider` (CFG 1.0) → `SamplerCustomAdvanced`

## Tabella preset (definitiva)

| Preset | Steps | CFG | Shift V | Shift A | Tau | LoRA (strength 1.0) |
|--------|-------|-----|---------|---------|-----|---------------------|
| Native Base (FL2VA) | 28–32 | 1.0 | 6.0 | 3.0 | 1.00 | nessuno (bypass) |
| Native Turbo (FL2VA) | 8 | 1.0 | 12.0 | 4.0 | 1.30 | minimax_h3_fl2v_turbo_8step_v1.0_768p_comfyui_bf16 |
| R2VA Native | 25–30 | 1.0 | 4.0 | 3.0 | 1.00 | minimax_h3_ref_lora_rank_256_bf16 (obbligatorio) |
| R2VA Turbo | 6–8 | 1.0 | 6.0 | 4.0 | 1.30 | minimax_h3_ref2v_turbo_8step_v1.0_768p_comfyui_bf16 |
| 10Eros Max Beta5 | 30–40 | 1.0 | 6.0 | 3.0 | 0.85–1.00 | nessuno (bypass) |
| 10Eros Turbo | 8 | 1.0 | 12.0 | 4.0 | 1.30 | lightx2v_hybrid-4to8step-full-fusion_Turbo_pruned |

## Modelli (INT8 puro — no NVFP4)

- DiT: `minimax_h3_fl2va_pruned_int8_convrot.safetensors` / `minimax_h3_ref2va_pruned_int8_convrot.safetensors` (Comfy-Org)
- 10Eros: `10Eros_Max_h3_hybrid_beta5_int8.safetensors` (TenStrip)
- Text encoder: `qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors` (Momoking Heretic NVFP4, uncensored) — CLIPLoader type `minimax`

## Args di avvio ComfyUI

`--highvram --fast-disk --disable-auto-launch --fast fp16_accumulation --cuda-malloc --enable-triton-backend --force-fp16`

## Note

- NVFP4: rimossi — perdita di qualità rilevante; accelerazione via LoRA turbo + sol-attn + triton backend.
- `ModelAttentionBackend` va inserito a mano tra LoraLoader e BlockSparseAttention se manca nel workflow.
- 10Eros Beta5 è il checkpoint NON-turbo: per la modalità turbo applicare il LoRA `lightx2v_hybrid` esterno (strength 1.0).
