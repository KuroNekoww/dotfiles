# dotfiles — Aether 桌面系统

基于 [chezmoi](https://chezmoi.io) 管理的 CachyOS + Niri + KDE Plasma 混合桌面配置。

## 环境概览

| 类别 | 方案 |
|---|---|
| 发行版 | CachyOS (Arch Linux) |
| 窗口管理器 | [niri](https://github.com/YaLTeR/niri) — 可滚动平铺 Wayland 合成器 |
| 桌面外壳 | [noctalia](https://github.com/noctalia/noctalia) — 面板、Dock、通知、控制中心 |
| Shell | fish |
| 输入法 | fcitx5-rime |
| 包管理 | pacman + paru (AUR) |

## 快速还原

### 1. 安装基础包

```bash
# 系统更新 & 基础工具
sudo pacman -Syu chezmoi git paru fish
```

### 2. 克隆并应用配置

```bash
# chezmoi 会直接克隆仓库到 ~/.local/share/chezmoi 并应用所有配置
chezmoi init --apply KuroNekoww
```

### 3. 安装全部软件包

```bash
# 原生包
sudo pacman -S --needed alacritty btop cava chafa chezmoi claude-code duf fastfetch \
  fcitx5-rime ffmpegthumbs ffmpegthumbnailer fish github-cli glances gpu-screen-recorder \
  haruna kate kcalc kdeconnect kdegraphics-thumbnailers kdialog kinfocenter meld \
  micro neovim niri obs-studio paru pavucontrol ripgrep starship superfile yazi \
  dolphin gwenview spectacle ark mark-shot plasma-desktop plasma-nm plasma-pa \
  plasma-firewall plasma-browser-integration plasma-login-manager bluedevil \
  powerdevil kscreen kde-gtk-config wireplumber pipewire-pulse pipewire-alsa \
  networkmanager kvantum xsettingsd openrgb ttf-jetbrains-mono-nerd ttf-meslo-nerd \
  ttf-opensans cantarell-fonts awesome-terminal-fonts noto-fonts-cjk

# AUR 包
paru -S --needed clipse flclash-bin google-chrome linuxqq noctalia
```

### 4. 重启会话

```bash
# 重新登录或重启
systemctl reboot
```

## 配置文件覆盖

```
.config
├── alacritty/         # 终端模拟器 + noctalia 主题
├── btop/              # 资源监视器主题
├── cava/              # 音频可视化 (config + shaders + 3 个主题)
├── clipse/            # 剪贴板管理器
├── environment.d/     # 环境变量 (fcitx5, KDE 配色)
├── fastfetch/         # 系统信息展示 (含头像)
├── fcitx5/            # 输入法框架 (含 rime 配置)
├── fish/              # Shell 配置
├── gtk-3.0/ & gtk-4.0/  # GTK 主题、窗口装饰、noctalia 配色
├── mark-shot/         # 截图标注工具
├── niri/              # 窗口管理器 (动画/键位/布局/配色等 9 个模块)
├── noctalia/          # 桌面外壳 (面板/Dock/通知/插件/莫兰迪主题)
├── starship.toml      # Shell 提示符
└── superfile/         # 终端文件管理器 + 20 个主题
.local/share
├── color-schemes/     # KDE 莫兰迪暗色方案 (由 morandi-gen.py 生成)
└── fcitx5/
    ├── rime/          # Rime 输入方案自定义
    └── themes/morandi/  # fcitx5 莫兰迪皮肤
```

## 主题系统

壁纸切换时，`morandi-gen.py` 自动从壁纸提取配色，生成莫兰迪色系并注入到：

- niri 焦点环 (`niri/cfg/colors.kdl`)
- GTK3/4 窗口装饰 (`gtk-{3,4}.0/colors.css`)
- alacritty 终端 (`alacritty/themes/noctalia.toml`)
- starship 提示符
- btop 资源监视器
- cava 音频可视化
- fastfetch 系统信息
- KDE 全局配色 (`color-schemes/Morandi-dark.colors`)
- fcitx5 输入法皮肤
- OBS Studio 主题

## 已安装软件包

### 核心系统

| 包名 | 功能 | 来源 |
|---|---|---|
| `linux-cachyos` / `linux-cachyos-lts` | CachyOS 优化内核 | pacman |
| `linux-firmware` | 硬件固件 | pacman |
| `amd-ucode` | AMD CPU 微码 | pacman |
| `mesa` / `vulkan-radeon` / `opencl-mesa` | AMD GPU 驱动 | pacman |
| `lib32-mesa` / `lib32-vulkan-radeon` | 32 位 GPU 支持 | pacman |
| `plasma-desktop` | KDE Plasma 桌面 | pacman |
| `plasma-nm` | 网络管理 | pacman |
| `plasma-pa` | 音频控制 | pacman |
| `plasma-firewall` | 防火墙 (ufw) | pacman |
| `plasma-browser-integration` | 浏览器集成 | pacman |
| `plasma-login-manager` | 登录管理器 | pacman |
| `bluedevil` | 蓝牙管理 | pacman |
| `powerdevil` | 电源管理 | pacman |
| `kscreen` | 显示器管理 | pacman |
| `kde-gtk-config` | GTK 主题同步 | pacman |
| `wireplumber` / `pipewire-pulse` / `pipewire-alsa` | 音频服务 | pacman |
| `networkmanager` | 网络服务 | pacman |

### 桌面环境 / 外壳

| 包名 | 功能 | 来源 |
|---|---|---|
| `niri` | 可滚动平铺 Wayland 合成器 | pacman |
| `noctalia` | 面板/Dock/通知/控制中心 | AUR |
| `xsettingsd` | X 应用 DPI/主题守护 | pacman |
| `kvantum` | Qt 主题引擎 | pacman |

### 终端工具

| 包名 | 功能 | 来源 |
|---|---|---|
| `alacritty` | GPU 加速终端模拟器 | pacman |
| `fish` | 现代化 Shell | pacman |
| `starship` | 跨 Shell 提示符 | pacman |
| `yazi` | 终端文件管理器 | pacman |
| `superfile` | 终端文件管理器 (备选) | pacman |
| `btop` | 资源监视器 | pacman |
| `glances` | 系统监控 | pacman |
| `duf` | 磁盘使用查看 | pacman |
| `fastfetch` | 系统信息展示 | pacman |
| `chafa` | 终端图片查看 | pacman |
| `cava` | 音频可视化 | pacman |
| `chezmoi` | 配置文件管理 | pacman |
| `clipse` | 剪贴板管理器 | AUR |
| `micro` | 轻量终端编辑器 | pacman |
| `neovim` | 编辑器 | pacman |
| `ripgrep` | 代码搜索 | pacman |
| `github-cli` | GitHub CLI | pacman |

### 输入法

| 包名 | 功能 | 来源 |
|---|---|---|
| `fcitx5-rime` | Fcitx5 + Rime 输入引擎 | pacman |

### 浏览器

| 包名 | 功能 | 来源 |
|---|---|---|
| `google-chrome` | Chrome 浏览器 | AUR |

### 文件管理

| 包名 | 功能 | 来源 |
|---|---|---|
| `dolphin` | KDE 文件管理器 | pacman |
| `kio-admin` | 管理员权限操作 | pacman |
| `ffmpegthumbs` / `ffmpegthumbnailer` | 视频缩略图 | pacman |
| `kdegraphics-thumbnailers` | 图像缩略图 | pacman |
| `gwenview` | 图片查看器 | pacman |
| `ark` | 压缩包管理 | pacman |

### 媒体

| 包名 | 功能 | 来源 |
|---|---|---|
| `haruna` | 视频播放器 | pacman |
| `obs-studio` | 直播/录屏 | pacman |
| `gpu-screen-recorder` | GPU 屏幕录制 | pacman |
| `vlc-plugins-all` | VLC 编解码器全集 | pacman |
| `libdvdcss` | DVD 解密 | pacman |
| `spectacle` | 截图工具 | pacman |
| `mark-shot` | 截图标注 | pacman |

### 网络 / 代理

| 包名 | 功能 | 来源 |
|---|---|---|
| `flclash-bin` | Clash 代理客户端 | AUR |
| `xsettingsd` | X 应用配置守护 | pacman |

### 通讯

| 包名 | 功能 | 来源 |
|---|---|---|
| `linuxqq` | QQ Linux 版 | AUR |
| `kdeconnect` | 手机-电脑联动 | pacman |

### 系统工具

| 包名 | 功能 | 来源 |
|---|---|---|
| `paru` | AUR 包管理器 | pacman |
| `chwd` | CachyOS 硬件检测 | pacman |
| `cachyos-hello` | CachyOS 系统信息 | pacman |
| `cachyos-kernel-manager` | 内核管理 | pacman |
| `fwupd` | 固件更新 | pacman |
| `grub-hook` | GRUB 自动更新 | pacman |
| `reflector` | 镜像源排序 | pacman |
| `rebuild-detector` | AUR 重建检测 | pacman |
| `logrotate` | 日志轮转 | pacman |
| `ufw` | 防火墙 | pacman |
| `plocate` | 文件索引搜索 | pacman |
| `claude-code` | AI 编程助手 | AUR |

### 开发工具

| 包名 | 功能 | 来源 |
|---|---|---|
| `base-devel` | 编译工具链 | pacman |
| `git` | 版本控制 | pacman |
| `meld` | 差异对比 | pacman |
| `python` / `python-packaging` / `python-defusedxml` | Python 运行时 | pacman |

### 字体

| 包名 | 功能 | 来源 |
|---|---|---|
| `noto-fonts` / `noto-fonts-cjk` / `noto-fonts-emoji` | 全局字体 | pacman |
| `ttf-jetbrains-mono-nerd` | 等宽 Nerd Font | pacman |
| `ttf-meslo-nerd` | 等宽 Nerd Font | pacman |
| `ttf-opensans` | 无衬线字体 | pacman |
| `cantarell-fonts` | GNOME 默认字体 | pacman |
| `awesome-terminal-fonts` | 终端图标字体 | pacman |

### CachyOS 定制

| 包名 | 功能 | 来源 |
|---|---|---|
| `cachyos-settings` | 系统预设 | pacman |
| `cachyos-kde-settings` | KDE 预设 | pacman |
| `cachyos-fish-config` | fish 预设 | pacman |
| `cachyos-emerald-kde-theme-git` | Emerald KDE 主题 | pacman |
| `cachyos-nord-kde-theme-git` | Nord KDE 主题 | pacman |
| `cachyos-iridescent-kde` | Iridescent KDE 主题 | pacman |
| `cachyos-wallpapers` | CachyOS 壁纸 | pacman |
| `cachyos-mirrorlist` | 镜像列表 | pacman |
| `cachy-update` | 系统更新工具 | pacman |

### 导出当前包列表

```bash
# 导出原生包（不含依赖）
pacman -Qqen > pacman-packages.txt
# 导出 AUR 包
pacman -Qqm > aur-packages.txt
```
