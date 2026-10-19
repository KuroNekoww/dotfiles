# dotfiles-new

CachyOS + niri + Noctalia 桌面环境的 [chezmoi](https://chezmoi.io) 配置仓库，用于在新系统上快速还原当前环境。

> 旧的 `~/dotfiles` 仓库作为参考保留，本仓库是从「当前已清理干净的系统」重新导出的版本：
> 已移除 Morandi 取色脚本、v4 插件、以及所有由 Noctalia 模板自动生成的配色文件。

## 环境概览

| 类别 | 方案 |
|---|---|
| 发行版 | CachyOS (Arch Linux) |
| 窗口管理器 | [niri](https://github.com/YaLTeR/niri) — 滚动平铺 Wayland 合成器 |
| 桌面外壳 | [noctalia](https://github.com/noctalia/noctalia) — 面板 / Dock / 通知 / 控制中心 |
| 配色 | Noctalia theme templates（14 个模板，见下） |
| Shell | fish + starship |
| 输入法 | fcitx5-rime |
| 登录管理器 | plasmalogin |
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
├── fish/                shell 配置
├── gtk-3.0/ gtk-4.0/    GTK 设置（noctalia.css 由模板生成）
├── Kvantum/             Qt 主题引擎
├── mark-shot/           截图标注
├── micro/               编辑器（含语法高亮）
├── niri/                窗口管理器（模块化 cfg/*.kdl）
├── noctalia/            Noctalia 主配置 + 主题模板清单
├── qt5ct/               Qt5 配置
├── private_fcitx5/      输入法（0600）
├── private_superfile/   文件管理器（0600）
├── xsettingsd/          XSettings 兼容
├── fish/                shell 配置（含 fisher / nvm 插件）
├── mimeapps.list        默认应用关联
├── user-dirs.dirs       XDG 目录（桌面/下载/文档…）
├── libinput-gestures.conf  触摸板手势
└── starship.toml        提示符
dot_gtkrc-2.0            GTK2 字体/主题

dot_local/share/
└── fcitx5/rime/         Rime 自定义方案

packages-native.txt          core/extra/cachyos 软件包
packages-archlinuxcn.txt     archlinuxcn 软件包（mark-shot、rime-ice 等）
packages-aur.txt             AUR 软件包
dconf-gnome-interface.ini    外观设置（主题/字体/光标/明暗）的 dconf 导出
```

> 仓库里**没有任何脚本**：装包、启服务、改 shell、导入外观都由下面的命令手动完成。

## 第三方仓库

`packages-archlinuxcn.txt` 里的 4 个包来自 archlinuxcn，CachyOS 默认没启用：

```bash
# /etc/pacman.conf 末尾追加
[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch

# 导入 keyring 后再装包
sudo pacman -Sy archlinuxcn-keyring
```

这 4 个包必须在启用 archlinuxcn 之后再安装。

## 不包含 / 无法还原的内容

**有意排除（隐私或机器本地）：**
SSH/GPG 密钥、浏览器数据、QQ/Clash/KDE Connect、钱包、剪贴板历史、
Rime 用户词库与同步数据（`user.yaml` / `installation.yaml` / `*.userdb` / `build/` / `sync/`）、
`gpu-screen-recorder` 恢复 token、图片素材（`~/图片`）、`~/.local/state`、dconf 二进制。

**没有纳入仓库（需要的话可以 add 进来）：**
KDE 应用自身的配置（`dolphinrc`、`katerc`、`gwenviewrc`、`spectaclerc`、`kdeglobals`、
`kglobalshortcutsrc`、`kwinrc`、`plasmashellrc` 等），以及 `shelly`、`LauncherX` 这类
单个应用自己的状态文件。它们不影响桌面能不能用，只影响这些应用内部的偏好。

**由程序重新生成（不必纳入仓库）：**
`gtk-{3,4}.0/noctalia.css`、`niri/noctalia.kdl`、各应用主题文件、`color-schemes/noctalia.colors`、
`window_decorations.css`、`gtk-*/colors.css`（后两个由 KDE 的 `kde-gtk-config` 生成）。

## 首次还原（新系统）

前提：CachyOS/Arch 已装好，能联网，用户名相同（默认 `kuronekoww`）。

```bash
# 1) 基础依赖
sudo pacman -S --needed base-devel git chezmoi

# 2) 先启用 archlinuxcn（需要其中的 mark-shot / rime-ice 等）
#    /etc/pacman.conf 末尾追加：
#    [archlinuxcn]
#    Server = https://repo.archlinuxcn.org/$arch
sudo pacman -Sy archlinuxcn-keyring

# 3) 克隆并应用配置（只写入配置文件，不装包）
chezmoi init --apply KuroNekoww/dotfiles-new

# 4) 安装软件包（列表来自仓库）
sudo pacman -S --needed $(cat ~/.local/share/chezmoi/packages-native.txt)
sudo pacman -S --needed $(cat ~/.local/share/chezmoi/packages-archlinuxcn.txt)
paru -S --needed $(cat ~/.local/share/chezmoi/packages-aur.txt)

# 5) 启用服务
sudo systemctl enable --now NetworkManager bluetooth ufw avahi-daemon \
    systemd-resolved systemd-timesyncd systemd-oomd switcheroo-control
sudo systemctl enable --now ananicy-cpp nvidia-powerd flclash-helper plasmalogin

# 6) 登录 shell 改为 fish
chsh -s /usr/bin/fish

# 7) 导入外观（主题/字体/光标/明暗；dconf 是二进制，无法直接放仓库）
dconf load /org/gnome/desktop/interface/ < ~/.local/share/chezmoi/dconf-gnome-interface.ini

# 8) 重启
systemctl reboot
```

> 如果以后新机器用户名不是 `kuronekoww`，先按下面「按机器调整」替换路径，再执行第 3 步。

首次登录后：

1. niri 启动 → 自动拉起 `noctalia`、`clipse`、polkit；
2. Noctalia 读取 `~/.config/noctalia/config.toml` 里的模板清单，自动生成所有配色文件
   （gtk `noctalia.css`、`niri/noctalia.kdl`、alacritty 主题、btop/cava 主题、KDE 配色、
   fcitx5 皮肤、micro/superfile 主题等）；
3. 验证：

```bash
noctalia config validate
niri validate
noctalia msg templates-apply   # 如果某个主题文件没生成，手动重刷
```

### 还原后需要按机器调整的地方

| 位置 | 说明 |
|---|---|
| `~/.config/niri/cfg/display.kdl` | 输出名 `eDP-2`、分辨率/缩放 |
| `~/.config/noctalia/config.toml` | `[shell].avatar_path`、`[wallpaper].directory`、`[wallpaper.default]` 指向 `~/图片/...` |
| `~/.config/noctalia/config.toml` | `[lockscreen_widgets]` 里的输出名 `eDP-1` / `eDP-2` 需与实际显示器一致 |
| `~/.config/fastfetch/config.jsonc` | `logo.source` 指向 `/home/kuronekoww/...` |
| 用户名不同 | `grep -rl "/home/kuronekoww" ~/.local/share/chezmoi \| xargs sed -i 's\|/home/kuronekoww\|/home/新用户\|g'` |

图片素材不在仓库里：把头像和壁纸放回 `~/图片/`，或在 GUI 里重新指定（`wallpaper.directory` / `avatar_path`）。

## 日常同步（本机 → 仓库）

本仓库当前是一个独立的 git 工作区（`~/dotfiles-new`）。有两种用法：

### 方式 A：临时指定 source（不改现有 chezmoi 配置，推荐先这样用）

```bash
# 查看差异
chezmoi --source ~/dotfiles-new diff

# 把本机改动写回新仓库
chezmoi --source ~/dotfiles-new re-add ~/.config/niri ~/.config/noctalia

# 只应用新仓库（会覆盖本机同名文件，先 diff）
chezmoi --source ~/dotfiles-new apply
```

### 方式 B：让 chezmoi 永久使用新仓库

编辑 `~/.config/chezmoi/chezmoi.toml`：

```toml
sourceDir = "/home/kuronekoww/dotfiles-new"
```

之后直接 `chezmoi re-add` / `chezmoi apply` 就作用在新仓库上。
（注意：这样 `~/.local/share/chezmoi` 里的旧仓库就不再是活动 source。）

### 更新包列表

```bash
pacman -Qqen | sort > ~/dotfiles-new/packages-native.txt
pacman -Qqem | sort > ~/dotfiles-new/packages-aur.txt
```

## 同步到 GitHub

### 首次推送

1. 在 GitHub 新建一个**空的**仓库（不要勾选 README / .gitignore），名字例如 `dotfiles-new`。
2. 在本地提交并推送：

```bash
cd ~/dotfiles-new

git init -b main              # 首次才需要
git config user.name  "KuroNekoww"
git config user.email "2079810443@qq.com"
git add -A
git commit -m "init: dotfiles-new (Clean CachyOS + niri + Noctalia setup)"

# SSH（推荐，需已配置 SSH key）
git remote add origin git@github.com:KuroNekoww/dotfiles-new.git
# 或 HTTPS
# git remote add origin https://github.com/KuroNekoww/dotfiles-new.git

git push -u origin main
```

### 日常更新

```bash
cd ~/dotfiles-new
git add -A
git commit -m "chore: sync dotfiles"
git push
```

如果 diff 里出现 `noctalia.css`、`noctalia.kdl`、各主题文件：正常不会出现在 git 中
（`.chezmoiignore` 已排除）；若出现了说明是手动 `git add -f` 过，请撤掉。

## 主题文件说明

配色全部由 Noctalia 的 theme templates 生成，仓库里只保存「模板清单」：

- 内置：`niri`、`starship`、`gtk3`、`gtk4`、`alacritty`、`btop`、`cava`、`kcolorscheme`、`qt`
- 社区：`fastfetch`、`fcitx5`、`obs`、`micro`、`superfile`

因此仓库里刻意**不含**任何生成的颜色文件；配置中指向这些文件的语句也做了移除或回退，
由模板在首次应用时补上。OBS 主题需要手动在 OBS 设置里选一次 `matugen`。

## 备注

- 本仓库基于 live 系统导出，`~/dotfiles`（旧）保持原样，可随时对照。
- 若以后自行添加其他应用配色，优先走 Noctalia 模板，不要手写色值。
- 仓库不含任何脚本；包列表、dconf 导出、README 命令即可完成还原。
