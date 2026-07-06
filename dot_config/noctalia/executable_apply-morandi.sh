#!/bin/bash
# Apply Morandi palette from Noctalia wallpaper colors
# Called by noctalia's wallpaper_changed hook (v5)
# v5 compat: noctalia theme still generates JSON from wallpaper image

WALLPAPER_PATH=$(noctalia msg wallpaper-get 2>/dev/null)
if [ -n "$WALLPAPER_PATH" ] && [ -f "$WALLPAPER_PATH" ]; then
    noctalia theme "$WALLPAPER_PATH" --scheme muted --dark -o ~/.config/noctalia/colors.json
    python3 ~/.config/noctalia/morandi-gen.py --wallpaper "$WALLPAPER_PATH"
else
    python3 ~/.config/noctalia/morandi-gen.py
fi
