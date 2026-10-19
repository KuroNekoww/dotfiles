#!/usr/bin/env bash
# 首次还原：启用常用系统服务
set -uo pipefail

# 必备服务（存在才启用）
services=(
    NetworkManager
    bluetooth
    ufw
    avahi-daemon
    systemd-resolved
    systemd-timesyncd
    systemd-oomd
    switcheroo-control
)

# 可选服务（装了才启用）
optional=(
    ananicy-cpp
    nvidia-powerd
    flclash-helper
    plasmalogin
)

for s in "${services[@]}"; do
    if systemctl list-unit-files "$s.service" >/dev/null 2>&1; then
        sudo systemctl enable --now "$s" 2>/dev/null \
            && echo "已启用 $s" \
            || echo "启用 $s 失败（可稍后手动处理）"
    fi
done

for s in "${optional[@]}"; do
    sudo systemctl enable --now "$s" 2>/dev/null && echo "已启用 $s"
done
