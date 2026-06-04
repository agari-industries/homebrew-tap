class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/agari-industries/agari"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.23.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "21c87e3764a6c12a649d1db0bcaad290dbaa50cc15d3fcd135108a4479a8b56f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.23.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "414b4d40c84154436a14eb85a1422b0aa462cc524ac775446d113739f0585d2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.23.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e6700ef3fc569223615f1c2bfd8733b4c66f7c8a3b8983d16fdd88871d6ebf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.23.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "33ed6b1cf8501de9e70bcb724d7d02c387936522f0c85ab68446998c99cca1f9"
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
