class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://agari.org/"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.27.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "e0002b22e753806676a05e327544e8a87ecd8d5a52436c6b048105a1c168bd28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.27.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "ac9680ea74aed97d13834f46d98c343000cb9ddd87c758b4d1d85082246ff2af"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.27.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "053d7bcc26322bf5662f891136e5f1a80f4d50495c210bb323ff2c9ad17a2a6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.27.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7392f127b0c0cbf526e8e48b014e07d49cc56e28aa3f530d5e29423d308b9b5"
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
