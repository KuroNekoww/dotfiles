# Alacritty

GPU 加速终端模拟器配置。

## 文件说明

- `alacritty.toml` - 主配置文件

## 配置详情

### 窗口

- 标题：`Alacritty@CachyOS`
- 透明度：0.88
- 内边距：16px
- 默认窗口大小：100 列 × 30 行
- 深色窗口装饰

### 字体

- 主字体：JetBrainsMono Nerd Font（Regular / Bold / Italic / Bold Italic）

### 颜色主题

- 背景/前景与 16 色调色板全部由 Noctalia 的 `alacritty` 模板生成（`themes/noctalia.toml`，经 `[general] import` 引入）
- `alacritty.toml` 本身不再写死任何颜色，只保留 `draw_bold_text_with_bright_colors`
- 光标：Beam 形状，始终闪烁

### 光标

- 形状：Beam（竖线）
- 闪烁：Always
- 厚度：0.15

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+C` | 复制 |
| `Ctrl+Shift+V` | 粘贴 |
| `Ctrl+Shift+F` | 前向搜索 |
| `Ctrl+Shift+B` | 后向搜索 |
| `Ctrl+L` | 清除日志通知 |
| `Ctrl+0` | 重置字体大小 |
| `Shift+PageUp/PageDown` | 滚动 |
| `Shift+Home/End` | 滚动到顶部/底部 |

## 相关链接

- [Alacritty 官网](https://alacritty.org/)
- [配置文档](https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd)
