#!/usr/bin/env bash
# 首次还原：安装官方仓库与 AUR 软件包（chezmoi run_once 自动执行）
set -euo pipefail

src="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}"
native="$src/packages-native.txt"
aur="$src/packages-aur.txt"

if [[ ! -f $native ]]; then
    echo "找不到软件包列表：$native" >&2
    exit 1
fi

mapfile -t pkgs < <(grep -vE '^[[:space:]]*(#|$)' "$native")
echo "==> 安装官方仓库软件包（${#pkgs[@]} 个）"
sudo pacman -S --needed --noconfirm "${pkgs[@]}"

if command -v paru >/dev/null 2>&1 && [[ -f $aur ]]; then
    mapfile -t aurpkgs < <(grep -vE '^[[:space:]]*(#|$)' "$aur")
    if ((${#aurpkgs[@]})); then
        echo "==> 安装 AUR 软件包（${#aurpkgs[@]} 个）"
        paru -S --needed --noconfirm "${aurpkgs[@]}"
    fi
else
    echo "==> 未找到 paru，跳过 AUR 软件包。装好 paru 后可手动执行："
    echo "    paru -S --needed $(tr '\n' ' ' < "$aur" 2>/dev/null || true)"
fi
