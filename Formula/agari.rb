class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://agari.org/"
  version "0.25.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.25.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "5d64fb322bde07e3d9f1da5ae60044c9ae9d6062c7b708212c921c7829417a07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.25.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "13d0fa17aa38d192e214aaeb9239a036346ce10ff09c439a66157d654f380e59"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agari-industries/agari/releases/download/v0.25.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca330b51bc914ddb08ba68da7d24982f164db00dfa91d7eb5f01b201a6769ee7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agari-industries/agari/releases/download/v0.25.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecefd253d191e4954316935ac80245bdb05de8777ecbb9d80382a807d3a08875"
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
