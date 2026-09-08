## MiniMax H3 — R2VA (Reference to Video)

Generates video+audio from reference images, locking character identity, style and appearance.

### Reference Images

The workflow loads **2 images** (reference sheet / character sheet). Qwen3-VL analyzes both and automatically generates Subject and Picture definitions for each.

| Slot | Node | Description |
|------|------|-------------|
| 1 | LoadImage (image) | Character 1 reference sheet — analyzed by Qwen as `[SBJ1]` |
| 2 | LoadImage (image2) | Character 2 reference sheet — analyzed by Qwen as `[SBJ2]` |

Each reference sheet can contain multiple views (front, side, outfit) of the same character. Qwen interprets them as **one single Subject**.

> **Note:** Color palette swatches sometimes present in character sheets are automatically ignored by Qwen — they will not appear as scene elements.

### Prompt Tags

Use these shorthand tags in the custom prompt field:

| Tag | Meaning | Example |
|-----|---------|---------|
| `[SBJ1]` | Subject 1 (character from ref image 1) | `[SBJ1] walks into the room` |
| `[SBJ2]` | Subject 2 (character from ref image 2) | `[SBJ2] turns around` |
| `[D]...[/D]` | Spoken dialogue | `[SBJ1] whispers [D]I missed you[/D]` |
| `[SPK1]` | Speaker 1 (dialogue attribution) | Assigned automatically by Qwen |
| `[SPK2]` | Speaker 2 | Assigned automatically by Qwen |

**Example prompt:**
```
[SBJ1] kisses [SBJ2] in a dimly lit bedroom, [SBJ2] whispers [D]don't stop[/D]
```

### Audio / Video References

If needed, use manual tags in the custom prompt:
- `[A1]audio description[/A1]` for audio reference
- `[V1]video description[/V1]` for video reference

### Settings

- **ref_image_size**: `match` = scale to output resolution (faster) · `max` = keep 2048px (stronger identity, slower)
- **Sampler**: `res_multistep` with `beta` or `normal` scheduler
- **Duration**: 5s / 10s / 15s (select matching QwenVL preset)
- **Resolution**: 768px short edge, max 1344px long edge, multiples of 32

### Required Models

- `minimax_h3_ref2va_pruned_nvfp4_convrot_int8.safetensors` (diffusion)
- `minimax_h3_video_vae_fp16.safetensors` + `minimax_h3_audio_vae_fp32.safetensors` (VAE)
- `qwen3vl_32b_heretic_minimax_h3_nvfp4.safetensors` (text encoder)
- `minimax_h3_turbo_v4_step600_ema.safetensors` (Turbo LoRA)
