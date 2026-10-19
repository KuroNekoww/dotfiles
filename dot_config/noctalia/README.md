# Noctalia 配置

Noctalia v5（当前 5.3.0）桌面 Shell 配置。**所有应用配色由 Noctalia 内置 theme templates 生成**，不再使用外部取色脚本。

## 文件说明

- `config.toml` —— 唯一手写的配置。改完用 `noctalia config validate` 校验
- `Base.ReaperTheme` —— Reaper 主题文件，与本 shell 无关（历史遗留，可另行归档）

## 配置分层

1. `~/.config/noctalia/*.toml` —— 手写配置（本目录）
2. `~/.local/state/noctalia/settings.toml` —— GUI 里改的设置，**最后加载、优先级最高**

两层都会被监视并热重载。如果发现手写值不生效，先看 `settings.toml` 里是不是有同名覆盖项。

## 主题模板（唯一的取色来源）

内置：`niri`、`starship`、`gtk3`、`gtk4`、`alacritty`、`btop`、`cava`、`kcolorscheme`、`qt`
社区：`fastfetch`、`fcitx5`、`obs`

在 `config.toml` 的 `[theme.templates]` 中启用。常用命令：

```bash
noctalia config validate        # 校验配置
noctalia msg templates-apply    # 用当前调色板重新渲染所有模板
noctalia msg theme-mode-toggle  # 明暗模式切换
```

生成物（**由模板写入，不要手改**）：

| 应用 | 路径 |
| --- | --- |
| GTK 3 / 4 | `~/.config/gtk-3.0/noctalia.css`、`~/.config/gtk-4.0/noctalia.css` |
| niri | `~/.config/niri/noctalia.kdl`（`config.kdl` 末尾 `include`） |
| Alacritty | `~/.config/alacritty/themes/noctalia.toml`（经 `import` 引入） |
| Starship | `~/.config/starship.toml` 中的 `[palettes.noctalia]` 块 |
| btop | `~/.config/btop/themes/noctalia.theme`（`btop.conf` 设 `color_theme = "noctalia"`） |
| Cava | `~/.config/cava/themes/noctalia`（`config` 设 `theme = "noctalia"`） |
| Fastfetch | `~/.config/fastfetch/themes/noctalia.jsonc` |
| fcitx5 | `~/.local/share/fcitx5/themes/noctalia/theme.conf`（`classicui.conf` 设 `Theme=noctalia`） |
| KDE / Qt | `~/.local/share/color-schemes/noctalia.colors`（`kdeglobals` 中 `ColorScheme=Noctalia`） |
| OBS | `~/.config/obs-studio/themes/matugen.obt`（需在 OBS 里手动选择一次） |

## 关于旧配色方案

旧的 Morandi 取色流程（`apply-morandi.sh`、`morandi-gen.py`、`colors.json`、`wallpaper_changed` hook、niri `cfg/colors.kdl`）已全部删除。

没有 Noctalia 模板的应用（Limine 引导背景、Clash Verge、FlClash、Godot）会保留最后一次生成的颜色，不再随壁纸变化。

## Chezmoi

本目录受 Chezmoi 管理：

- 直接改 `~/.config/noctalia/` 后运行 `chezmoi re-add ~/.config/noctalia`
- 或直接改源码目录 `~/.local/share/chezmoi/dot_config/noctalia/`
