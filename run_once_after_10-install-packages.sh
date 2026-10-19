#!/usr/bin/env bash
# 首次还原：安装软件包（chezmoi run_once 自动执行）
#   packages-native.txt        core / extra / cachyos 仓库
#   packages-archlinuxcn.txt   archlinuxcn 仓库（需先启用，见 README）
#   packages-aur.txt           AUR
set -euo pipefail

src="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}"
native="$src/packages-native.txt"
cn="$src/packages-archlinuxcn.txt"
aur="$src/packages-aur.txt"

read_list() {
    local f=$1
    [[ -f $f ]] || return 0
    grep -vE '^[[:space:]]*(#|$)' "$f"
}

if [[ ! -f $native ]]; then
    echo "找不到软件包列表：$native" >&2
    exit 1
fi

mapfile -t pkgs < <(read_list "$native")
echo "==> 安装官方仓库软件包（${#pkgs[@]} 个）"
sudo pacman -S --needed --noconfirm "${pkgs[@]}"

# archlinuxcn 不是 Arch/CachyOS 默认仓库
if [[ -f $cn ]]; then
    if grep -q '^\[archlinuxcn\]' /etc/pacman.conf; then
        mapfile -t cnpkgs < <(read_list "$cn")
        echo "==> 安装 archlinuxcn 软件包（${#cnpkgs[@]} 个）"
        sudo pacman -S --needed --noconfirm "${cnpkgs[@]}"
    else
        echo "==> 未配置 archlinuxcn 仓库，跳过：$(tr '\n' ' ' < "$cn")"
        echo "    启用方法见 README 的「第三方仓库」一节，之后手动执行："
        echo "    sudo pacman -S --needed $(tr '\n' ' ' < "$cn")"
    fi
fi

if command -v paru >/dev/null 2>&1 && [[ -f $aur ]]; then
    mapfile -t aurpkgs < <(read_list "$aur")
    if ((${#aurpkgs[@]})); then
        echo "==> 安装 AUR 软件包（${#aurpkgs[@]} 个）"
        paru -S --needed --noconfirm "${aurpkgs[@]}"
    fi
else
    echo "==> 未找到 paru，跳过 AUR 软件包。装好 paru 后可手动执行："
    echo "    paru -S --needed $(tr '\n' ' ' < "$aur" 2>/dev/null || true)"
fi
