# dotfiles

CachyOS + niri + Noctalia 桌面环境的 [chezmoi](https://chezmoi.io) 配置仓库。

- **GitHub 仓库名**：`KuroNekoww/dotfiles`
- **本地工作副本**：任意目录（本文以 `~/dotfiles-new` 为例）
- **不含任何脚本**：装包、服务、shell、外观都由下面的手动命令完成
- **不含隐私数据**：见「隐私与不包含」

## 环境概览

| 类别 | 方案 |
|---|---|
| 发行版 | CachyOS (Arch Linux) |
| 窗口管理器 | [niri](https://github.com/YaLTeR/niri) — 滚动平铺 Wayland 合成器 |
| 桌面外壳 | [noctalia](https://github.com/noctalia/noctalia) — 面板 / Dock / 通知 / 控制中心 |
| 配色 | Noctalia theme templates（14 个模板） |
| Shell | fish + starship |
| 输入法 | fcitx5-rime（rime-ice） |
| 终端 | Alacritty |
| 登录管理器 | plasmalogin |
| 字体 | Inter + 更纱黑体 / Noto Sans CJK（见 `fontconfig/fonts.conf`） |
| 包管理 | pacman + paru (AUR) |

## 仓库内容

```
dot_config/
├── alacritty/           终端（颜色由模板生成）
├── btop/                资源监视器（主题由模板生成）
├── cava/                音频可视化
├── clipse/              剪贴板管理器
├── environment.d/       会话环境变量（fcitx5 / KDE 配色）
├── fastfetch/           系统信息（含头像）
├── fish/                shell 配置（含 fisher / nvm 插件）
├── fontconfig/          字体优先顺序（Inter / 更纱黑体 / Sarasa / Noto CJK）
├── gtk-3.0/ gtk-4.0/    GTK 设置（noctalia.css 由模板生成）
├── Kvantum/             Qt 主题引擎
├── libinput-gestures.conf  触摸板手势
├── mark-shot/           截图标注
├── micro/               编辑器（含语法高亮）
├── mimeapps.list        默认应用关联
├── niri/                窗口管理器（模块化 cfg/*.kdl）
├── noctalia/            Noctalia 主配置（含锁屏布局）
├── qt5ct/               Qt5 配置
├── private_fcitx5/      输入法（0600）
├── private_superfile/   文件管理器（0600）
├── user-dirs.dirs       XDG 目录（桌面/下载/文档…）
├── xsettingsd/          XSettings 兼容
└── starship.toml        提示符
dot_gtkrc-2.0            GTK2 字体/主题

dot_local/share/
└── fcitx5/rime/         Rime 自定义方案

packages-native.txt          core/extra/cachyos 软件包
packages-archlinuxcn.txt     archlinuxcn 软件包（mark-shot、rime-ice 等）
packages-aur.txt             AUR 软件包
dconf-gnome-interface.ini    外观（主题/字体/光标/明暗）的 dconf 导出
```

`packages-*.txt`、`dconf-*.ini`、`README.md` 已在 `.chezmoiignore` 中排除，不会被写进 `$HOME`。

## 第三方仓库（必须先做）

`packages-archlinuxcn.txt` 里的 4 个包来自 **archlinuxcn**，CachyOS 默认没有这个仓库：

```bash
# /etc/pacman.conf 末尾追加
[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch

sudo pacman -Sy archlinuxcn-keyring
```

## 首次还原（按顺序手动执行）

> 前提：CachyOS/Arch 已装好、能联网、用户名相同（默认 `kuronekoww`）。
> 用户名不同的话，先做「按机器调整」里的路径替换，再执行第 3 步。

### 1. 基础依赖

```bash
sudo pacman -S --needed base-devel git chezmoi
```

### 2. 启用 archlinuxcn

见上一节。

### 3. 拉取并应用配置

```bash
chezmoi init --apply KuroNekoww/dotfiles
```

只会写入配置文件，不装包。应用完可以检查一下：

```bash
chezmoi status          # 应为空
ls ~/.config/niri ~/.config/noctalia
```

### 4. 安装软件包

```bash
sudo pacman -S --needed $(cat ~/.local/share/chezmoi/packages-native.txt)
sudo pacman -S --needed $(cat ~/.local/share/chezmoi/packages-archlinuxcn.txt)
paru -S --needed $(cat ~/.local/share/chezmoi/packages-aur.txt)
```

### 5. 启用系统服务

```bash
sudo systemctl enable --now NetworkManager bluetooth ufw avahi-daemon \
    systemd-resolved systemd-timesyncd systemd-oomd switcheroo-control
sudo systemctl enable --now ananicy-cpp nvidia-powerd flclash-helper plasmalogin
```

### 6. 登录 shell 改为 fish

```bash
chsh -s /usr/bin/fish
```

### 7. 导入外观设置（主题 / 字体 / 光标 / 明暗）

Wayland 下 GTK 通过 portal 读取 dconf，`settings.ini` 只是回退，所以必须导入：

```bash
dconf load /org/gnome/desktop/interface/ < ~/.local/share/chezmoi/dconf-gnome-interface.ini
```

### 8. 重启

```bash
systemctl reboot
```

### 9. 首次登录后检查

```bash
noctalia config validate     # ✓ Config is valid
niri validate                # config is valid
noctalia msg templates-apply # 主题文件没自动生成时手动重刷
```

niri 启动会自动拉起 `noctalia`、`clipse`、polkit，Noctalia 按配置里的模板清单生成所有配色文件
（gtk `noctalia.css`、`niri/noctalia.kdl`、alacritty/btop/cava/fastfetch/micro/superfile 主题、
KDE 配色、fcitx5 皮肤等）。

OBS 主题需要在 OBS「设置 → 外观」里手动选一次 `matugen`。

## 按机器调整

| 位置 | 需要改什么 |
|---|---|
| 用户名 | 先替换：`grep -rl "/home/kuronekoww" ~/.local/share/chezmoi \| xargs sed -i 's\|/home/kuronekoww\|/home/新用户\|g'` |
| `~/.config/niri/cfg/display.kdl` | 输出名 `eDP-2`、分辨率、缩放 |
| `~/.config/noctalia/config.toml` | `[shell].avatar_path`、`[wallpaper].directory`、`[wallpaper.default]` 指向 `~/图片/...`；`[lockscreen_widgets]` 里的 `eDP-1` / `eDP-2` 要跟实际输出一致 |
| `~/.config/fastfetch/config.jsonc` | `logo.source` 指向 `/home/kuronekoww/...` |
| 图片素材 | 头像、壁纸不在仓库里，放进 `~/图片/` 或在 GUI 里重新指定 |

## 隐私与不包含

**有意排除：** SSH/GPG 密钥、浏览器数据、QQ/Clash/KDE Connect、钱包、剪贴板历史、
Rime 用户词库与同步数据（`user.yaml` / `installation.yaml` / `*.userdb` / `build/` / `sync/`）、
`gpu-screen-recorder` 恢复 token、图片素材、`~/.local/state`、dconf 二进制。
完整规则见 `.chezmoiignore`。

**未纳入（应用内部偏好，按需自行 add）：** `dolphinrc`、`katerc`、`gwenviewrc`、`spectaclerc`、
`kdeglobals`、`kglobalshortcutsrc`、`kwinrc`、`plasmashellrc`、`shelly`、`LauncherX` 等。

**由程序生成，不必纳入：** `gtk-{3,4}.0/noctalia.css`、`niri/noctalia.kdl`、各应用主题文件、
`color-schemes/noctalia.colors`、`window_decorations.css`、`gtk-*/colors.css`
（后两个由 KDE 的 `kde-gtk-config` 生成，见「常见问题」）。

## 日常维护（本机 → 仓库 → GitHub）

本机工作副本是 `~/dotfiles-new`，chezmoi 用 `--source` 指向它即可：

```bash
# 把本机改动写回仓库
chezmoi --source ~/dotfiles-new re-add ~/.config/niri ~/.config/noctalia ...

# 比较差异
chezmoi --source ~/dotfiles-new diff
```

也可以让 chezmoi 永久使用这个目录：在 `~/.config/chezmoi/chezmoi.toml` 写

```toml
sourceDir = "/home/kuronekoww/dotfiles-new"
```

更新数据文件：

```bash
# 包列表（archlinuxcn 的 4 个包单独维护）
pacman -Qqen | grep -vE '^(archlinuxcn-keyring|mark-shot|rime-ice-git|rime-wanxiang-gram-zh-hans)$' \
  | sort > ~/dotfiles-new/packages-native.txt
pacman -Qqem | sort > ~/dotfiles-new/packages-aur.txt

# 外观
dconf dump /org/gnome/desktop/interface/ > ~/dotfiles-new/dconf-gnome-interface.ini
```

提交并推送：

```bash
cd ~/dotfiles-new
git add -A
git commit -m "chore: sync dotfiles"
git push
```

## 首次推送到 GitHub（仓库名 dotfiles）

GitHub 上已有 `KuroNekoww/dotfiles`（旧版历史），本仓库是重新导出的，历史和它不同，
所以第一次要**强制覆盖**：

```bash
cd ~/dotfiles-new

git remote add origin git@github.com:KuroNekoww/dotfiles.git
# 或 https://github.com/KuroNekoww/dotfiles.git

git push --force origin main
```

> 强制推送前确认远程没有需要保留的内容；旧的本地克隆 `~/dotfiles` 里仍有旧历史，
> 需要的话可以先备份成另一个分支。
>
> 如果不想覆盖历史：把新仓库推到别的分支（如 `git push origin main:next`），
> 在 GitHub 上比较后再合并/改默认分支。

推送完成后，新机器直接用 `chezmoi init --apply KuroNekoww/dotfiles` 还原。

## 主题文件说明

配色全部由 Noctalia 的 theme templates 生成，仓库里只保存「模板清单」：

- 内置：`niri`、`starship`、`gtk3`、`gtk4`、`alacritty`、`btop`、`cava`、`kcolorscheme`、`qt`
- 社区：`fastfetch`、`fcitx5`、`obs`、`micro`、`superfile`

因此配置里指向这些文件的语句做了移除或回退（alacritty 的 import、niri 的 include、
btop/cava 的 theme 行等），由模板在首次应用时补上。

## 常见问题

**配色没生成 / 某个应用还是旧颜色**
```bash
noctalia msg templates-apply
```

**装包时提示 archlinuxcn 包不存在**
第 2 步没做，或 `archlinuxcn-keyring` 没导入。

**`gtk-3.0/colors.css`、`window_decorations.css` 又出现了**
这是 KDE 的 `kde-gtk-config` 生成的 Breeze 调色板快照（不是本仓库的文件）。
它会在 KDE 应用/设置运行时重写；想彻底避免可以移除 `kde-gtk-config`
（无反向依赖），否则忽略即可——只影响 `*_breeze` 这套颜色名。

**OBS 没有跟随主题**
在 OBS 设置里手动选 `matugen`。

**字体不对**
本项目用 `fontconfig/fonts.conf` 控制字体优先级（sans → Inter，中文 → 更纱黑体 / Noto CJK），
外观字体本身在 dconf（`dconf-gnome-interface.ini`）。改完字体后重新导出 dconf 并同步仓库。
