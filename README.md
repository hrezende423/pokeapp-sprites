# pokeapp-sprites

Animated WebP sprite artwork for [Pokeapp](https://github.com/hrezende423/pokeapp),
national dex #001–493 (Gen 1–4).

**Asset hosting only** — no application code lives here. Every sprite is an
individual GitHub release asset with its own permanent, direct download URL.
Nothing is zipped.

## URL pattern

```
https://github.com/hrezende423/pokeapp-sprites/releases/download/{tag}/{id}-front-{n|s}[-{m|f}].webp
```

Examples:

```
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen1/001-front-n.webp
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen2/196-front-s.webp
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen4/493-front-s.webp
```

## Naming

| Part            | Meaning                                                        |
| --------------- | -------------------------------------------------------------- |
| `{id}`          | 3-digit zero-padded national dex id (`001`–`493`)              |
| `n` / `s`       | normal / shiny                                                 |
| `-m` / `-f`     | male / female — present only for species with a gender difference |

A species with no gender difference has exactly two files (`n`, `s`). A species
with a gender difference has four (`n-m`, `n-f`, `s-m`, `s-f`).

## Releases

Split by generation because GitHub allows
[up to 1000 assets per release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
and the full set is 1,174 files.

| Tag    | Dex range | Assets | Size      |
| ------ | --------- | ------ | --------- |
| `gen1` | 001–151   | 348    | 187.8 MiB |
| `gen2` | 152–251   | 244    | 129.5 MiB |
| `gen3` | 252–386   | 306    | 174.4 MiB |
| `gen4` | 387–493   | 276    | 154.0 MiB |
|        | **total** | **1174** | **645.7 MiB** |

All 493 species ids are present with no gaps.

## Metadata: `species-background-colors.json`

Detail-page background colours for the species detail view, one pair per
species, keyed by the same 3-digit zero-padded dex id the sprite filenames use:

```json
{
  "001": { "bg_dark": "#214533", "bg_light": "#7ebe9d" },
  "094": { "bg_dark": "#2a283a", "bg_light": "#7d78a0" }
}
```

All 493 ids, no gaps. `bg_light` / `bg_dark` are the light- and dark-mode
backgrounds for the artwork panel behind that species.

Derived from analysis of the official artwork (k-means clustering over the real
opaque pixels, largest cluster covering at least 6% of them at saturation 0.10 or
above, near-black and near-white excluded) followed by species-by-species human
curation — either a corrected colour or a deliberate reuse of another species'
pair where two species genuinely look alike (#121 reuses #110, #197 reuses #198,
and 20-odd more). Two more automated approaches were tried and rejected: a
synthetic hue reconstruction, and k-means plus an automated contrast-solver. The
simpler extraction plus direct review is the final answer, not a stopgap — see
the consuming app's design system for the full methodology and revision history.

It lives here rather than in the app because it is asset metadata about the
artwork, on the same footing as the sprite files it describes.

## Known naming exception

**#198 Murkrow** does not follow the convention above. It has a gender
difference, but its four files are `n`, `n-f`, `s`, `s-f` — using an unsuffixed
default plus `-f`, rather than the `-m`/`-f` pair used by the other 93 gendered
species. The unsuffixed files are presumably the male sprites, but that is an
inference, not something the filenames state. Consumers resolving a male variant
should special-case this id, or the files should be renamed to
`198-front-n-m.webp` / `198-front-s-m.webp` to match everything else.

Every other filename matches the convention exactly.
