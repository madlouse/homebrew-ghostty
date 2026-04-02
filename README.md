# Homebrew Tap — Ghostty + Cmux + Zed

> Ghostty + Cmux + Zed AI 多协作编程终端栈

## 安装

```bash
# 首次安装（一行命令搞定全部）
brew tap madlouse/ghostty https://github.com/madlouse/homebrew-ghostty
brew install ghostty-cmux

# 升级（自动拉取最新配置）
brew upgrade ghostty-cmux
```

安装后运行验证脚本确认状态：

```bash
bash setup/verify.sh
```

## 包含内容

| 工具 | 作用 |
|------|------|
| Cmux | AI Agent 多会话指挥中心（内置 libghostty 渲染）|
| Ghostty | 终端基座，支持原生分屏 / Quick Terminal |
| Zed | 代码编辑器 + AI Agent Panel |
| Starship | 跨 Shell prompt |
| fastfetch | 系统信息展示 |
| btop | 资源监控 |
| JetBrainsMono Nerd Font | 字体（含图标 glyph）|

## 设计特性

**幂等安装** — 内容一致时自动跳过，可重复执行无副作用：

```bash
bash setup/bootstrap.sh --dry-run  # 预览将要执行的操作
bash setup/bootstrap.sh             # 实际部署（幂等）
bash setup/bootstrap.sh --force      # 强制重新部署
```

**验证** — 安装后检查配置一致性（精确 diff，不只是文件存在性）：

```bash
bash setup/verify.sh
```

**Agent 友好** — 完整安装文档：[ghostty-optimization/AGENTS.md](https://github.com/madlouse/ghostty-optimization/blob/main/AGENTS.md)

## Formula

- `ghostty-cmux` — 完整 AI 编程终端栈

## 卸载

```bash
brew uninstall ghostty-cmux
```

## 配置文件源码

配置版本管理在 [ghostty-optimization](https://github.com/madlouse/ghostty-optimization) 仓库。
