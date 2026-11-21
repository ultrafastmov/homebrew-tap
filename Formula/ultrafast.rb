class Ultrafast < Formula
  desc "GPU video engine for agents: JSON documents in, video out"
  homepage "https://ultrafast.mov"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.1.0/ultrafast-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "cf8a4afa19a6a291e1596f190f34756fd7f6a1b564c457fa51f39c5c07d340de"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.1.0/ultrafast-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "751a4e00b01d4cebd9c6dc02e82ea1c685b585de6622aafb7dbeec0e238db852"
    end
  end

  def install
    libexec.install "ultrafast", "uf", Dir["slang-*"]
    bin.install_symlink libexec/"ultrafast", libexec/"uf"
    doc.install "README.md", "THIRD-PARTY.md", "licenses"
  end

  def caveats
    on_linux do
      <<~EOS
        ultrafast renders with Vulkan: it needs your GPU's Vulkan driver.
        Exports use ffmpeg, `uf voiceover` uses espeak-ng, and `uf ocr` and
        `uf reconstruct` use tesseract: install them with your package
        manager (or brew install ffmpeg espeak-ng tesseract).
      EOS
    end
  end

  # Without a GPU: the version, a template and the op vocabulary.
  test do
    assert_match version.to_s, shell_output("#{bin}/uf --version")
    system bin/"uf", "new", "title", testpath/"film.json"
    assert_path_exists testpath/"film.json"
    assert_match "gradient", shell_output("#{bin}/ultrafast ops")
  end
end
