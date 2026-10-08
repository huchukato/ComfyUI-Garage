# MiniMax H3 — Syntax Sheet

Due layer: **noi** scriviamo la sintassi comoda nel prompt utente → **QwenVL** traduce → **MMH3** riceve la sintassi nativa e la interpreta direttamente (nessun pre-processing, è testo che il modello legge).

Lingue lip-sync supportate: English, Italian, French, German, Spanish, Portuguese, Russian, Chinese, Japanese, Korean, Arabic.

## Identità e riferimenti

| MMH3 nativo | Sintassi comoda |
|---|---|
| `<Subject 1>` + `<Picture 1>` in subject_definitions | `(S1) è una character sheet di Jinx` — descrivi cos'è il contenuto, Qwen crea Subject+Picture |
| `<Subject 2>`/`<Subject 3>` + `<Picture 2>`/`<Picture 3>` | `(S2) è ...`, `(S3) è ...` — stessa cosa per gli altri slot immagine |
| `<Video 1>` | `(S4) è un video con ...` — Qwen scrive `<Video 1>` e la retention (motion/voice/style) |
| `retention_analysis` (`fully_preserved`, `partially_preserved`, `attribute_transfer`, `weak_reference`, `newly_generated`) | automatica — Qwen la deduce da come descrivi gli `(SN)` |
| audio retention (`fully_copy`, `partially_copy`, `reference`, `weak_reference`) | automatica — derivata da `(S4)` video |

> Slot fissi: `(S1)`,`(S2)`,`(S3)` = i 3 input immagine del workflow; `(S4)` = l'input video.

## Dialogo

| MMH3 nativo | Sintassi comoda |
|---|---|
| `(S1) speaks: <d>[English] "testo"</d>` | `(S1) dice "testo"` — verbo libero, qualsiasi lingua; lingua dedotta dal testo |
| `(S1) speaks: <d>[Italian] "testo"</d>` | `(S1) dice [IT] "testo"` — tag a 2 lettere forza la lingua |
| `(S1) speaks off-screen: <d>[Lang] "..."</d>` | `(S1) dice fuori campo "..."` |
| `says in an off-screen voiceover: <d>[Lang] "..."</d>` | `(VO) dice "testo"` — voce senza soggetto a schermo |
| battuta troncata → `<cutoff>` | automatico — Qwen aggiunge `<cutoff>` se sfora la durata |
| battuta che attraversa un cut → `<scenetrans>` | automatico — Qwen lo gestisce |

### Codici lingua `[XX]`

| Tag | Lingua emessa |
|---|---|
| `[EN]` `[IT]` `[FR]` `[DE]` `[ES]` `[PT]` `[RU]` `[ZH]` `[JA]` `[KO]` `[AR]` | English, Italian, French, German, Spanish, Portuguese, Russian, Chinese, Japanese, Korean, Arabic |

## Camera

Nessun tag `[...]` richiesto: la camera si scrive in testo libero o con wildcards `__mmh3/camera/<move>__` (iniettabili inline, una per shot). Vocabolario nativo H3 che Qwen riconosce perfettamente:

| Movimento | Frase nativa |
|---|---|
| fermo | `static shot`, `locked off` |
| avanti/indietro | `push in`, `pull out` |
| focale | `zoom in`, `zoom out` |
| rotazione orizz./vert. | `pan left/right`, `tilt up/down` |
| traslazione orizz./vert. | `truck left/right`, `pedestal up/down` |
| intorno al soggetto | `arc shot`, `orbit` |
| segue il soggetto | `tracking shot` |
| shake | `shake slightly`, `shake strongly` |
| soggettiva | `POV` |
| rotazione sull'asse | `roll clockwise/counterclockwise`, `barrel roll` |
| extra (spec §9) | `swoop`, `whip-pan`, `dive` |

Modificatori opzionali: `with small/large amplitude`, `at slow/fast speed`.

Wildcards: `__mmh3/camera__` (random) o `__mmh3/camera/truck__`, `__mmh3/camera/arc__`, ecc. — il dropdown camera globale è stato rimosso dai form (un tag solo non copre un video multi-shot).

## Audio / musica

| MMH3 nativo | Sintassi comoda |
|---|---|
| `overall_soundscape:` — ambiente/foley, voce solo se dialogo richiesto | testo libero ("rombo della jeep, vento del deserto") o omesso |
| `non_diegetic_music:` | `N/A` di default — richiesta esplicita ("con colonna sonora epica") o `__mmh3/music__` |

## Shots, VFX, lighting, acting

| MMH3 nativo | Sintassi comoda |
|---|---|
| `[Shot N]` + timestamp `At 00:04.000` | testo libero ("a 4 secondi succede X") o omesso — Qwen distribuisce i shot |
| VFX: trigger + forma + moto + conseguenza (§10) | testo libero — "esplosione con detriti e onda d'urto", Qwen espande |
| lighting/materiali (§11) | testo libero — "neon rosa, riflessi sul metallo", Qwen espande |
| acting/emozioni (§13) | testo libero — "nervosa", Qwen converte in micro-azioni osservabili |
| master template §18 | è già il FORMAT dentro ogni preset — Qwen lo riempie |

## Regole trasversali

- La battuta è **verbatim**: Qwen non traduce né riscrive il testo tra virgolette — la lingua in `[XX]` deve combaciare.
- Voce/tone/accento → `overall_soundscape`, mai dentro le virgolette.
- Nessun contenuto parlato richiesto → niente dialogo, niente voce inventata, soundscape solo ambiente/foley.
- `non_diegetic_music` = `N/A` a meno di richiesta esplicita.
