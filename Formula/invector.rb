class Invector < Formula
  desc "TUI inspector for Vector component topology."
  homepage "https://github.com/janweinkauff/invector"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-aarch64-apple-darwin.tar.xz"
      sha256 "2171469de86a9c9eeccce54488184b4af542e06d40f56052292de755d02355ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-x86_64-apple-darwin.tar.xz"
      sha256 "05588d6deb4ef57df134b4c7585289ba2bfa65b67246d298d7c7bb6b0589bf91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ae5feab087aeafdb29b7656f6582482cad7eab8623c32e7fe284a815f9a3c7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b306166e6dc307a37c8a38f4459863a42dbf8576989bc3e787bce173454753ce"
    end
  end

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
    bin.install "invector" if OS.mac? && Hardware::CPU.arm?
    bin.install "invector" if OS.mac? && Hardware::CPU.intel?
    bin.install "invector" if OS.linux? && Hardware::CPU.arm?
    bin.install "invector" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
