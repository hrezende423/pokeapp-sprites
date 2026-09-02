# pokeapp-sprites

Animated WebP sprites for [Pokeapp](https://github.com/hrezende423/pokeapp),
national dex #001–493 (Gen 1–4).

**Asset hosting only** — no application code lives here. Every sprite is an
individual GitHub release asset with its own permanent, direct download URL.
Nothing is zipped.

## Two sets, two namespaces

| Set                 | Tags                | Files | Filenames                              |
| ------------------- | ------------------- | ----- | -------------------------------------- |
| Animated artwork    | `gen1`–`gen4`       | 1,174 | `{id}-front-{n\|s}[-{m\|f}].webp`       |
| Black/White sprites | `bw-gen1`–`bw-gen4` | 2,340 | `{id}-bw-{front\|back}-{n\|s}[-f].webp` |

They are separate namespaces on purpose: the `-bw-` segment means the two can
never collide inside a release, and the tags keep them in separate releases
anyway. Both cover all 493 species.

The first set is the high-resolution animated artwork. The second is
**PokéAPI's own animated sprites, converted** — see its section below.

## URL pattern — animated artwork

```
https://github.com/hrezende423/pokeapp-sprites/releases/download/{tag}/{id}-front-{n|s}[-{m|f}].webp
```

Examples:

```
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen1/001-front-n.webp
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen2/196-front-s.webp
https://github.com/hrezende423/pokeapp-sprites/releases/download/gen4/493-front-s.webp
```

## Naming — animated artwork

| Part        | Meaning                                                           |
| ----------- | ----------------------------------------------------------------- |
| `{id}`      | 3-digit zero-padded national dex id (`001`–`493`)                 |
| `n` / `s`   | normal / shiny                                                    |
| `-m` / `-f` | male / female — present only for species with a gender difference |

A species with no gender difference has exactly two files (`n`, `s`). A species
with a gender difference has four (`n-m`, `n-f`, `s-m`, `s-f`).

## Releases — animated artwork

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

## Black/White animated sprites (`bw-gen1`–`bw-gen4`)

PokéAPI's animated sprites, converted from GIF to animated WebP.

**This is the only animated set PokéAPI has.** It lives at
`sprites/pokemon/versions/generation-v/black-white/animated` in
[PokeAPI/sprites](https://github.com/PokeAPI/sprites), across eight directories
(front/back × regular/shiny × ±female), and it is GIF. Emerald and Crystal
animated in-game and have no animated sprites upstream at all.

```
https://github.com/hrezende423/pokeapp-sprites/releases/download/{tag}/{id}-bw-{front|back}-{n|s}[-f].webp
```

```
.../bw-gen1/001-bw-front-n.webp
.../bw-gen1/003-bw-back-s-f.webp
.../bw-gen4/493-bw-front-s.webp
```

| Part              | Meaning                                                  |
| ----------------- | -------------------------------------------------------- |
| `{id}`            | 3-digit zero-padded national dex id (`001`–`493`)        |
| `front` / `back`  | which side                                               |
| `n` / `s`         | normal / shiny                                           |
| `-f`              | the female variant, where upstream has one (93 species)  |

| Tag       | Dex range | Assets   | Notes                    |
| --------- | --------- | -------- | ------------------------ |
| `bw-gen1` | 001–151   | 688      |                          |
| `bw-gen2` | 152–251   | 488      |                          |
| `bw-gen3` | 252–386   | 612      |                          |
| `bw-gen4` | 387–493   | 552      |                          |
|           | **total** | **2340** | 86.3 MiB, all 493 species |

### Conversion

`gif2webp -m 6 -min_size`, i.e. lossless. Pixel art has to survive exactly, and
a lossy pass on a 37×38 sprite is both visibly wrong and no smaller — measured,
the whole set went from 90.0 MiB of GIF to 86.3 MiB of WebP, a 4% saving. The
point of converting was one animated format and 8-bit alpha, not bytes.

### Transparency

**The source GIFs are already transparent** — audited across 18 species, every
corner pixel is alpha 0. There was no white background to remove. What GIF
conversion is notorious for is the RGB *under* those pixels, which is white and
only surfaces if something interpolates them; lossless WebP is allowed to
rewrite the colour of fully-transparent pixels while compressing (cwebp's
default, i.e. not `-exact`), so that white is not in these files. Consumers
should still draw them nearest-neighbour: they are 2–3× sprites and smoothing
them is what would reintroduce a soft edge.

### Gaps, which are upstream's

Four species have **no front-shiny** animated GIF: #096 Drowzee, #097 Hypno,
#098 Krabby, #099 Kingler. And #133 Eevee has no female file despite being
flagged `has_gender_differences` in PokéAPI's own species data.

So the set is not a product of the naming rule — it is a census, and a consumer
has to know which of the eight slots exists per species or it will request a
404. The consuming app carries that as an 8-bit-per-species bitmask
(`src/data/animatedSprites.ts`) with a script that re-derives it from the eight
directory listings and cross-checks it against these releases.

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
