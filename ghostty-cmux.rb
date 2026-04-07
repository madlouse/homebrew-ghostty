# Formula for Ghostty + Cmux + Zed AI 编程终端栈
#
# Tap setup (run once per machine):
#   brew tap madlouse/ghostty https://github.com/madlouse/homebrew-ghostty
#
# Install:
#   brew install ghostty-cmux
#
# Daily config sync:
#   ghostty-cmux-sync
#
# Verify current install state:
#   ghostty-cmux-verify
#
# One-time legacy migration:
#   brew upgrade ghostty-cmux   # install the sync wrapper and re-run post_install
#
# Uninstall:
#   brew uninstall ghostty-cmux

class GhosttyCmux < Formula
  desc "Ghostty + Cmux + Zed — AI Agent 多协作编程终端栈"
  homepage "https://github.com/madlouse/ghostty-optimization"
  url "https://github.com/madlouse/ghostty-optimization/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6d6278b51f27aec0f8312e267cf839685012f01ed962e752365c594bb1881c9a"
  license "MIT"
  version "1.1.0"
  revision 2

  # Cmux only supports macOS
  depends_on macos: :ventura

  # CLI tools installable as Homebrew formulae
  depends_on "starship" => :recommended
  depends_on "fastfetch" => :recommended
  depends_on "btop" => :recommended
  depends_on "zsh-autosuggestions" => :recommended
  depends_on "zsh-syntax-highlighting" => :recommended

  # Note: Cmux and Zed are installed via Brewfile (bootstrap.sh handles this)
  # They are not Homebrew formulae and cannot be listed as depends_on

  def install
    # Install entire tree into libexec/ghostty-optimization/
    (libexec/"ghostty-optimization").install Dir["*"]

    (bin/"ghostty-cmux-sync").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      sync_url="${GHOSTTY_CMUX_SYNC_URL:-https://raw.githubusercontent.com/madlouse/ghostty-optimization/main/setup/sync.sh}"
      tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/ghostty-cmux-sync-wrapper.XXXXXX")"
      trap 'rm -rf "$tmp_dir"' EXIT

      curl -fsSL "$sync_url" -o "$tmp_dir/sync.sh"
      chmod +x "$tmp_dir/sync.sh"
      exec bash "$tmp_dir/sync.sh" "$@"
    SH
    chmod 0755, bin/"ghostty-cmux-sync"

    (bin/"ghostty-cmux-verify").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      managed_root="${GHOSTTY_CMUX_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/ghostty-cmux}"
      managed_verify="$managed_root/source/current/setup/verify.sh"
      packaged_verify="#{libexec}/ghostty-optimization/setup/verify.sh"

      if [[ -x "$managed_verify" ]]; then
        exec bash "$managed_verify" "$@"
      fi

      exec bash "$packaged_verify" "$@"
    SH
    chmod 0755, bin/"ghostty-cmux-verify"
  end

  def post_install
    sync_cmd = bin/"ghostty-cmux-sync"

    ohai "Syncing latest ghostty-optimization snapshot and running bootstrap..."
    system sync_cmd.to_s
  end

  def caveats
    <<~EOS
      Ghostty + Cmux + Zed 环境已安装！

      开始使用：

        多 Agent 模式:
          open -a Cmux
          cw .             # 为当前目录新建 Workspace
          cc               # 在当前 Cmux workspace 中分屏启动 Claude Code
          zed .            # 编辑文件

        轻量独立模式:
          open -a Ghostty

      配置文件位置:
        Ghostty/Cmux: ~/.config/ghostty/config
        Zed:          ~/.config/zed/settings.json

      升级配置:
        ghostty-cmux-sync           # 拉取 main 最新快照并重新运行 bootstrap
        ghostty-cmux-sync --dry-run # 预览更新

      验证安装:
        ghostty-cmux-verify         # 运行已打包的验证入口
        ghostty-cmux-verify | cat   # 适合保存/转发验证输出

      旧版本迁移:
        brew upgrade ghostty-cmux   # 升级一次以安装 ghostty-cmux-sync wrapper

      完整文档:
        #{libexec}/ghostty-optimization/README.md
    EOS
  end

  test do
    # Smoke test: verify bootstrap payload and sync wrapper exist
    assert_predicate libexec/"ghostty-optimization/setup/bootstrap.sh", :exist?
    assert_predicate libexec/"ghostty-optimization/setup/bootstrap.sh", :executable?
    assert_predicate bin/"ghostty-cmux-sync", :exist?
    assert_predicate bin/"ghostty-cmux-sync", :executable?
    assert_predicate libexec/"ghostty-optimization/setup/verify.sh", :exist?
    assert_predicate libexec/"ghostty-optimization/setup/verify.sh", :executable?
    assert_predicate bin/"ghostty-cmux-verify", :exist?
    assert_predicate bin/"ghostty-cmux-verify", :executable?
  end
end
