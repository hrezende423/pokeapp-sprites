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

## Known naming exception

**#198 Murkrow** does not follow the convention above. It has a gender
difference, but its four files are `n`, `n-f`, `s`, `s-f` — using an unsuffixed
default plus `-f`, rather than the `-m`/`-f` pair used by the other 93 gendered
species. The unsuffixed files are presumably the male sprites, but that is an
inference, not something the filenames state. Consumers resolving a male variant
should special-case this id, or the files should be renamed to
`198-front-n-m.webp` / `198-front-s-m.webp` to match everything else.

Every other filename matches the convention exactly.
