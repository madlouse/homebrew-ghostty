# Formula for Ghostty + Cmux + Zed AI 编程终端栈
#
# Tap setup (run once per machine):
#   brew tap madlouse/ghostty https://github.com/madlouse/homebrew-ghostty
#
# Install:
#   brew install ghostty-cmux
#
# Upgrade:
#   brew upgrade ghostty-cmux   # reinstall re-runs post_install
#
# Uninstall:
#   brew uninstall ghostty-cmux

class GhosttyCmux < Formula
  desc "Ghostty + Cmux + Zed — AI Agent 多协作编程终端栈"
  homepage "https://github.com/madlouse/ghostty-optimization"
  url "https://github.com/madlouse/ghostty-optimization/archive/refs/heads/main.tar.gz"
  sha256 "de0c84a31511ce3448ae5887e44fcca871e7b47b8eb0bf712d44726ac09f3921"
  license "MIT"
  version "1.0.0"

  # Cmux only supports macOS
  depends_on macos: :ventura

  # Core tools
  depends_on "manaflow-ai/cmux/cmux" => :recommended
  depends_on "zed" => :recommended
  depends_on "starship" => :recommended
  depends_on "fastfetch" => :recommended
  depends_on "btop" => :recommended
  depends_on "zsh-autosuggestions" => :recommended
  depends_on "zsh-syntax-highlighting" => :recommended

  # Font
  depends_on "font-jetbrains-mono-nerd-font" => :recommended

  def install
    # Clone the ghostty-optimization repo to libexec
    ohai "Cloning ghostty-optimization config repository..."
    system "git", "clone",
           "--depth", "1",
           "--branch", "main",
           "https://github.com/madlouse/ghostty-optimization.git",
           buildpath/"ghostty-optimization"

    libexec.install buildpath/"ghostty-optimization"
  end

  def post_install
    setup_script = libexec/"ghostty-optimization/setup/bootstrap.sh"

    # Run bootstrap in non-interactive mode
    # --force: skip dry-run, apply all configs
    # Redirect output to /dev/null to avoid cluttering terminal
    ohai "Running setup (this may prompt for sudo on first run)..."
    system "bash", setup_script.to_s, "--force"
  end

  def caveats
    <<~EOS
      Ghostty + Cmux + Zed 环境已安装！

      开始使用：

        多 Agent 模式:
          open -a Cmux
          cw myproject     # 新建 Workspace
          cc               # 启动 Claude Code
          zed .            # 编辑文件

        轻量独立模式:
          open -a Ghostty

      配置文件位置:
        Ghostty/Cmux: ~/.config/ghostty/config
        Zed:          ~/.config/zed/settings.json

      升级配置:
        brew upgrade ghostty-cmux   # 重新拉取最新配置

      完整文档:
        #{libexec}/ghostty-optimization/README.md
    EOS
  end

  test do
    # Smoke test: verify bootstrap script exists and is executable
    assert_predicate libexec/"ghostty-optimization/setup/bootstrap.sh", :exist?
    assert_predicate libexec/"ghostty-optimization/setup/bootstrap.sh", :executable?
  end
end
