#!/usr/bin/env bash
# Install omarchy-edges CLI + Omarchy top-bar plugin.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/omarchy-edges" "$HOME/.config/omarchy/plugins/omarchy-edges"

install -m 755 "$ROOT/bin/omarchy-edges" "$HOME/.local/bin/omarchy-edges"
install -m 755 "$ROOT/share/omarchy-edges/omarchy_edges.py" "$HOME/.local/share/omarchy-edges/omarchy_edges.py"
install -m 644 "$ROOT/plugin/manifest.json" "$HOME/.config/omarchy/plugins/omarchy-edges/manifest.json"
install -m 644 "$ROOT/plugin/BarWidget.qml" "$HOME/.config/omarchy/plugins/omarchy-edges/BarWidget.qml"

# Wire Hyprland persistence helpers if missing
MON="$HOME/.config/hypr/monitors.lua"
if [[ -f "$MON" ]] && ! grep -q 'omarchy-edges.inc.lua' "$MON"; then
  echo "Note: add reserved loading from ~/.config/hypr/omarchy-edges.inc.lua in monitors.lua (see README)."
fi

AUTO="$HOME/.config/hypr/autostart.lua"
if [[ -f "$AUTO" ]] && ! grep -q 'omarchy-edges apply' "$AUTO"; then
  printf '\n-- omarchy-edges: re-apply crop after login\no.launch_on_start("omarchy-edges apply")\n' >> "$AUTO"
fi

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate "$HOME/.config/omarchy/plugins/omarchy-edges" || true
  omarchy plugin enable omarchy-edges 2>/dev/null || true
  omarchy bar put omarchy-edges --before omarchy.power 2>/dev/null || true
  omarchy-shell shell rescanPlugins 2>/dev/null || true
fi

echo "Installed. Run: omarchy-edges gui"
echo "Bar: click the 󰩫 icon (right-click = select region)"
