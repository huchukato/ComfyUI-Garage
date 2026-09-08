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

### Action Tags (NSFW)

Trigger interaction between subjects without writing a full prompt. Qwen generates the complete scene description.

| Tag | Action | Example |
|-----|--------|---------|
| `[ACTION]` | Random NSFW interaction (Qwen chooses) | `[ACTION]` or `[ACTION] in a shower` |
| `[KISS]` | Passionate / french kiss | `[SBJ1] [KISS] [SBJ2]` |
| `[ORAL]` | Oral sex | `[ORAL] on the couch` |
| `[SEX]` | Full intercourse | `[SEX] in a bedroom` |
| `[TOUCH]` | Intimate caressing / groping | `[TOUCH]` |
| `[GRIND]` | Grinding / tribbing / body friction | `[SBJ1] [GRIND] [SBJ2]` |

**Rules:**
- Case-insensitive (`[kiss]` = `[KISS]` = `[Kiss]`)
- Combinable with subject tags and free text: `[SBJ1] [KISS] [SBJ2] in a candlelit room`
- If used alone (e.g. just `[ACTION]`), Qwen generates the full scene context
- Anatomical consistency is enforced — actions match the subjects' genders from reference images

### Audio / Video References

If needed, use manual tags in the custom prompt:
- `[A1]audio description[/A1]` for audio reference
- `[V1]video description[/V1]` for video reference

### Settings

- **ref_image_size**: `match` = scale to output resolution (faster) · `max` = keep 2048px (stronger identity, slower)
- **Sampler**: `res_multistep` with `beta` or `normal` scheduler
- **Duration**: 5s / 10s / 15s (select matching QwenVL preset)
- **Resolution**: 768px short edge, max 1344px long edge, multiples of 32


