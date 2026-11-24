class Ultrafast < Formula
  desc "GPU video engine for agents: JSON documents in, video out"
  homepage "https://ultrafast.mov"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.2.1/ultrafast-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "e33616a1a908fc905bb1afef8fb14adfdef5374e0c0e6c3cbe902fa9fdeed9aa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ultrafastmov/ultrafast/releases/download/v0.2.1/ultrafast-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "37ce12111a309f93ae502c49529c8ded19084541a2e5cc74889f1cad9d562c71"
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
