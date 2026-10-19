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
└── starship.toml        提示符

dot_local/share/
└── fcitx5/rime/         Rime 自定义方案

packages-native.txt      官方仓库软件包列表
packages-aur.txt         AUR 软件包列表
run_once_after_10-install-packages.sh   首次还原自动装包
run_once_after_20-enable-services.sh    首次还原启用服务
run_once_after_30-set-default-shell.sh  登录 shell 改为 fish
```

## 不包含的内容（隐私 / 机器本地）

SSH/GPG 密钥、浏览器数据、QQ/Clash/KDE Connect 数据、钱包、剪贴板历史、
Rime 用户数据、`gpu-screen-recorder` 恢复 token、图片素材、`~/.local/state`。
完整清单见 `.chezmoiignore`。

## 首次还原（新系统）

前提：CachyOS/Arch 已装好，能联网，用户名相同（默认 `kuronekoww`）。

```bash
# 1) 基础依赖
sudo pacman -S --needed base-devel git chezmoi

# 2) 克隆并应用配置（会跑 run_once 脚本：装包 → 启服务 → 改 shell）
chezmoi init --apply KuroNekoww/dotfiles-new

# 3) 重启
systemctl reboot
```

> 仓库为私有的话用 SSH：`chezmoi init --apply git@github.com:KuroNekoww/dotfiles-new.git`

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
| `~/.config/noctalia/config.toml` | `[shell].avatar_path`、`[wallpaper].directory` 指向 `~/图片/...` |
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

### 重新运行 run_once 脚本

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
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
