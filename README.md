# omarchy-edges

Crop Hyprland / Omarchy desktop content into the **healthy region** of a physically damaged laptop panel.

Useful when the top, bottom, or a corner of the screen is dead from a fall (or similar): windows, the bar, and overlays stay inside undamaged glass. Optional black masks cover the broken edges.

## Features

- Live margin editor (top / bottom / left / right)
- Mouse selection of the healthy rectangle (`slurp`)
- Persists across Hyprland reloads via `~/.config/hypr/omarchy-edges.inc.lua`
- Omarchy **top-bar** widget (`omarchy-edges`)
- Optional black edge masks (GTK4 layer-shell)

## Requirements

- Hyprland (Omarchy recommended)
- Python 3 + PyGObject (Gtk 4, Adwaita)
- `gtk4-layer-shell` (for black masks)
- `slurp` (region select)
- `hyprctl`, `notify-send`

## Install

```bash
./install.sh
```

This installs:

| Path | Purpose |
|------|---------|
| `~/.local/bin/omarchy-edges` | CLI |
| `~/.local/share/omarchy-edges/` | App |
| `~/.config/omarchy/plugins/omarchy-edges/` | Top-bar widget |

Then open the editor once and hit **Save**:

```bash
omarchy-edges gui
```

### Hyprland monitor reserved area

For the crop to survive `hyprctl reload`, load the generated include from `~/.config/hypr/monitors.lua`:

```lua
local safe = { top = 0, bottom = 0, left = 0, right = 0 }
local ok, loaded = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/omarchy-edges.inc.lua")
if ok and type(loaded) == "table" then
  safe = {
    top = tonumber(loaded.top) or 0,
    bottom = tonumber(loaded.bottom) or 0,
    left = tonumber(loaded.left) or 0,
    right = tonumber(loaded.right) or 0,
  }
end

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = "auto",
  reserved = safe,
})
```

Autostart (already appended by `install.sh` when missing):

```lua
o.launch_on_start("omarchy-edges apply")
```

## Usage

| Command | Action |
|---------|--------|
| `omarchy-edges` / `gui` | Interactive editor |
| `omarchy-edges select` | Draw healthy region |
| `omarchy-edges apply` | Apply saved crop |
| `omarchy-edges reset` | Clear crop |
| `omarchy-edges status` | Show current margins |

**Bar:** left-click opens the editor; right-click runs region select.

**Keys (optional):** bind `omarchy-edges gui` in Hyprland (e.g. `SUPER+SHIFT+Z`).

Margins are **logical / layout pixels** (after monitor scale). On a 2560×1600@2x panel, ~56 logical px ≈ 0.5″.

## Config

- `~/.config/omarchy/omarchy-edges.json` — margins + mask toggle
- `~/.config/hypr/omarchy-edges.inc.lua` — generated Hyprland reserved include

## License

MIT
