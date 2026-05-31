# ZMK Config — Corne 42-key (Cube Studio)

Firmware ZMK pour le Corne **42 touches** (3x6 + 3 thumb) version **Cube Studio** (PCB "Cherry v4"), avec nice!nano v2 + nice!epaper.

**Hardware**
- Shield: `corne_c` (Cube Studio, pins GPIO custom — pas foostan standard)
- Board: `nice_nano_v2`
- Display: `nice_epaper` (Sharp LS0xx, module mctechnology17/zmk-nice-oled)
- ZMK: v0.3.0

**Layout**
- 6 couches: QWERTY(0), Num/Sym(1), Utilitaire(2), Nav(3), Gaming(4), AZERTY(5)
- Modifiers dédiés sur thumbs (pas de home-row mods)
- Accents français via dead keys + US International (pas de couche accent)
- Combos bootloader gauche (E+R+S+T) et droite (Y+U+I+L)

## Architecture deux repos

Ce repo (`zmk-config`) est le **repo d'édition**, connecté au [Keymap Editor de Nick](https://nickcoutsos.github.io/keymap-editor/). Le build du firmware se fait dans le repo constructeur.

```
┌─────────────────────────────────────────────────────┐
│  Nick's Keymap Editor (web)                         │
│    ↓ push sur corne.keymap                          │
│  zmk-config (ce repo)                               │
│    ↓ sync-to-cube-studio.yml (workflow_dispatch)    │
│  zmk-corne-cube_studio (repo build)                 │
│    ↓ build.yml → firmware UF2                       │
│  Desktop/firmware-cube-studio/latest/                │
└─────────────────────────────────────────────────────┘
```

**Repos:**
1. **`LyesHammadouche/zmk-config`** (ce repo) — keymap + visualisation. Connected to Nick's Keymap Editor. `build.yaml` présent mais le build ici utilise `corne_cherry_v4` (GPIO foostan standard, **pas utilisable** sur le PCB Cube Studio). Le vrai firmware vient du repo constructeur.
2. **`LyesHammadouche/zmk-corne-cube_studio`** (fork du fabricant) — build firmware avec shield `corne_c` + ZMK v0.3.0 + nice_epaper. Firmware fonctionnel.

**Pipeline CI:**
- Push sur `zmk-config` → `sync-to-cube-studio.yml` envoie un `workflow_dispatch` à `zmk-corne-cube_studio`
- `zmk-corne-cube_studio` reçoit le keymap, build les UF2, artifacts dispos dans Actions
- Téléchargement firmware: via GitHub API (voir skill Hermes `zmk-keyboard-config`)

## Fichiers clés

- `config/corne.keymap` — keymap source (plain devicetree, compatible Nick's Editor)
- `config/corne.conf` — config display + tapping terms
- `config/west.yml` — ZMK source (main, pour le build local uniquement)
- `build.yaml` — config build ZMK main (GPIO foostan, **ne pas flasher**)
- `corne-layout.html` — visualisation HTML de toutes les couches

## Keymap

![Keymap drawing](images/keymaps/urchin_keymap.svg)

**Combos (Layer 0 uniquement):**

| Combo | Touches | Positions | Action |
|-------|---------|-----------|--------|
| CapsLock | ESC + BSPC | 0 + 11 | `&kp CLCK` |
| CapsWord | N + B | 30 + 29 | `&caps_word` |
| Nav toggle | O + P + BSPC | 9 + 10 + 11 | `&tog 3` |
| Game toggle | T + G + Y + H | 5 + 17 + 18 + 6 | `&tog 4` |
| AZERTY toggle | Q + W + E + R | 1 + 2 + 3 + 4 | `&tog 5` |
| NumLock | BSPC + TAB + ESC + RSHFT | 11 + 12 + 0 + 23 | `&kp LOCKING_NUM` |
| Bootloader L | E + R + S + T | 3 + 4 + 14 + 5 | `&bootloader` |
| Bootloader R | Y + U + I + L | 6 + 7 + 8 + 21 | `&bootloader` |

**Position map (42-key):**

```
Left row0:   0=ESC   1=Q   2=W   3=E   4=R   5=T
Right row0:  6=Y     7=U   8=I   9=O   10=P  11=BSPC
Left row1:   12=TAB  13=A  14=S  15=D  16=F  17=G
Right row1:  18=H    19=J  20=K  21=L  22=;  23=RSHFT
Left row2:   24=LCTL 25=Z  26=X  27=C  28=V  29=B
Right row2:  30=N    31=M  32='  33=.  34=/  35=DEL
Left thumb:  36      37    38
Right thumb: 39      40    41
```

## Flashing

1. Télécharger `firmware.zip` depuis [Actions du repo cube_studio](https://github.com/LyesHammadouche/zmk-corne-cube_studio/actions)
2. **Settings reset** (première fois uniquement): flasher `settings_reset` sur les DEUX moitiés
3. Flasher chaque moitié: `corne_c_left` sur la gauche, `corne_c_right` sur la droite
4. Mode bootloader: double-tap reset physique, OU combo bootloader (ERSL gauche, YUIL droite)
5. Glisser le `.uf2` sur le drive NICENANO → auto-eject

## Workflow d'édition

1. Ouvrir [Nick's Keymap Editor](https://nickcoutsos.github.io/keymap-editor/), charger ce repo
2. Éditer les couches visuellement
3. Sauvegarder dans l'éditeur → push sur zmk-config
4. Le sync CI dispatche le build cube_studio automatiquement
5. Télécharger le firmware depuis les artifacts du build cube_studio

## Références

- [Cube Studio manufacturer repo](https://github.com/felixm12138/zmk-corne-cube_studio)
- [ZMK firmware](https://zmk.dev)
- [Keymap Editor](https://nickcoutsos.github.io/keymap-editor/)
- [mctechnology17/zmk-nice-oled](https://github.com/mctechnology17/zmk-nice-oled) (display module)
