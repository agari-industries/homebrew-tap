class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://agari.org/"
  version "0.26.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.26.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "d378be104823d445c91b7dd3c0f3c3a27896f880120e2f75e39c6dabb538f930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.26.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "c667da0cee342b0d735abead7340c2694852ca521f1d2340055607f801906cb4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.26.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b135ecd264709e3efb620df3eb7db3893e3efb43389410d621079a9d9d5a9052"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.26.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74a344650f9549f0cc3b0cccc818a22b6171719b1937cb12f5ec42a56ec8cec4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "agari"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agari"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "agari"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "agari"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
