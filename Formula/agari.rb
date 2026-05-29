class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/agari-industries/agari"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.22.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "b44341b651dd3e7aea02069d0814895fde9f9c40430a908000c6441f7ee7b86e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.22.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "fc47c3fd8b1a6d838e9a50de2a96176a1c840d218be104d2fd230b7b90279d52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.22.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43a05897f5b87d6b2c1d2778ffb51d0c41af215a031ead800644f80d2e0bd47a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.22.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2bf88f2fc7696d10466fe5d25c6a1fa9b979c5b5b94fcf80ab4f2a4d7c85def6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agari" if OS.mac? && Hardware::CPU.arm?
    bin.install "agari" if OS.mac? && Hardware::CPU.intel?
    bin.install "agari" if OS.linux? && Hardware::CPU.arm?
    bin.install "agari" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
