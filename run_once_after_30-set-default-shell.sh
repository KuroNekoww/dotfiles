#!/usr/bin/env bash
# 首次还原：把登录 shell 改为 fish
set -euo pipefail

target=/usr/bin/fish
current=$(getent passwd "$(id -un)" | cut -d: -f7)

if [[ ! -x $target ]]; then
    echo "未安装 fish，跳过（软件包脚本应已安装 fish）"
    exit 0
fi

if [[ $current == "$target" ]]; then
    echo "登录 shell 已经是 fish"
    exit 0
fi

echo "==> 将登录 shell 从 $current 改为 $target"
chsh -s "$target" || echo "chsh 失败，请手动执行：chsh -s /usr/bin/fish"
