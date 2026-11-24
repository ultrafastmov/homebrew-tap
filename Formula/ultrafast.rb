class Ultrafast < Formula
  desc "GPU video engine for agents: JSON documents in, video out"
  homepage "https://ultrafast.mov"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.2.2/ultrafast-0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "813cc3fa8bb29a7cea61e4371f65cec4c9fe6c9065c0bcfed1944aed5b8f574b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.2.2/ultrafast-0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41392acd698849509190a525a333ceed5ce5b17f2b89c099c6e8540df7faa5aa"
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
