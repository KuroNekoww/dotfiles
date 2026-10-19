#!/usr/bin/env bash
# 首次还原：把外观设置写进 dconf。
# Wayland 下 GTK 通过 xdg-desktop-portal 读取这些值，settings.ini 只是回退。
set -uo pipefail

if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings 不可用，跳过（缺少 glib2 / 无 DBus 会话）"
    exit 0
fi

set_interface() {
    gsettings set org.gnome.desktop.interface "$1" "$2" 2>/dev/null \
        && echo "已设置 $1 = $2" \
        || echo "跳过 $1（schema 不存在或会话不可用）"
}

set_interface gtk-theme             "Breeze"
set_interface icon-theme            "breeze-dark"
set_interface cursor-theme          "capitaine-cursors"
set_interface cursor-size           24
set_interface font-name             "Noto Sans 10"
set_interface document-font-name    "Noto Sans 10"
set_interface monospace-font-name   "Hack 10"
set_interface color-scheme          "prefer-dark"
set_interface text-scaling-factor   1.0
