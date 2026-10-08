## MiniMax H3 — R2VA (Reference to Video)

Generates video+audio from reference images, locking character identity, style and appearance.

### Reference Images

The workflow loads **2 images** (reference sheet / character sheet). Qwen3-VL analyzes both and automatically generates Subject and Picture definitions for each.

| Slot | Node | Description |
|------|------|-------------|
| 1 | LoadImage (image) | Character 1 reference sheet — analyzed by Qwen as `(S1)` |
| 2 | LoadImage (image2) | Character 2 reference sheet — analyzed by Qwen as `(S2)` |

Each reference sheet can contain multiple views (front, side, outfit) of the same character. Qwen interprets them as **one single Subject**.

> **Note:** Color palette swatches sometimes present in character sheets are automatically ignored by Qwen — they will not appear as scene elements.

### Prompt Syntax

Use the `(SN)` speaker/subject syntax in the custom prompt field:

| Syntax | Meaning | Example |
|--------|---------|---------|
| `(S1)` | Subject 1 (character from ref image 1) | `(S1) walks into the room` |
| `(S2)` | Subject 2 (character from ref image 2) | `(S2) turns around` |
| `(S3)` | Subject 3 (ref image 3) | `(S3) is a character sheet of Tifa` |
| `(S4)` | Reference video input | `(S4) is a video with the target voice` |
| `(SN) <verb> "text"` | Dialogue line, any verb/language | `(S1) dice "ciao"` |
| `(SN) <verb> [XX] "text"` | Dialogue with language tag | `(S1) says [IT] "come va?"` |
| `(VO) <verb> "text"` | Off-screen voiceover | `(VO) narrates "Meanwhile..."` |

Language codes `[XX]`: EN IT FR DE ES PT RU ZH JA KO AR → `<d>[Language]` in the MMH3 prompt.

**Example prompt:**
```
(S1) kisses (S2) in a dimly lit bedroom, (S2) whispers [IT] "non fermarti"
```

> See `MMH3_Syntax_Sheet.md` for the full comfy→native mapping.

### Settings

- **ref_image_size**: `match` = scale to output resolution (faster) · `max` = keep 2048px (stronger identity, slower)
- **Sampler**: `res_multistep` with `beta` or `normal` scheduler
- **Duration**: 5s / 10s / 15s (select matching QwenVL preset)
- **Resolution**: 768px short edge, max 1344px long edge, multiples of 32


