# Homebrew Tap — Ghostty + Cmux + Zed

## 安装

```bash
# 首次安装
brew tap madlouse/ghostty https://github.com/madlouse/homebrew-ghostty
brew install ghostty-cmux

# 升级
brew upgrade ghostty-cmux
```

## 包含内容

| 工具 | 作用 |
|------|------|
| Cmux | AI Agent 多会话指挥中心 (内置 libghostty) |
| Zed | 代码编辑器 + AI Agent Panel |
| Starship | 跨 Shell prompt |
| fastfetch | 系统信息 |
| btop | 资源监控 |
| JetBrainsMono Nerd Font | 字体 (图标支持) |

安装后自动运行 `bootstrap.sh` 部署全部配置。

## Formula

- `ghostty-cmux` — 完整 AI 编程终端栈

## 卸载

```bash
brew uninstall ghostty-cmux
```

## 配置文件源码

配置版本管理在 [ghostty-optimization](https://github.com/madlouse/ghostty-optimization) 仓库。
