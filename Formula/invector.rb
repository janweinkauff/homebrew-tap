class Invector < Formula
  desc "TUI inspector for Vector component topology."
  homepage "https://github.com/janweinkauff/invector"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-aarch64-apple-darwin.tar.xz"
      sha256 "ad8493e6ee4dab6b7dcb1df6b1ab0cf68b5e44321fb16e9757b7372b650ee2fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-x86_64-apple-darwin.tar.xz"
      sha256 "439ccb287ce749da044130f723b8b633a899aae1be0cc41cf70e3b2f52a7cbd7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ac3a7323d60150320e5d1c8e8f9c0ecf48a1d6a03e73fc76b0874a66ac94662"
    end
    if Hardware::CPU.intel?
      url "https://github.com/janweinkauff/invector/releases/download/0.0.1/invector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19681ee41405bcb12acee4cee4071fd45f03c4190750c60d7ea8eab891e15cd1"
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
