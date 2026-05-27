cask "tzexpand" do
  version "0.4.7"
  sha256 "9bb0c79e158103258b69801c6f5878881b4b0c8b659c4e1860d8565b7ab43459"

  url "https://github.com/ferniethedev/homebrew-tzexpand/releases/download/v#{version}/TZExpand-#{version}.zip"
  name "TZExpand"
  desc "Hotkey timezone expander for any macOS text input"
  homepage "https://github.com/ferniethedev/homebrew-tzexpand"

  app "TZExpand.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/TZExpand.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/dev.fernie.tzexpand.plist",
  ]

  caveats <<~EOS
    TZExpand needs Accessibility permission to read selected text and paste
    expansions. After first launch, grant access in:

        System Settings → Privacy & Security → Accessibility

    Default hotkey: Control + Option + T  (configure in Settings).
  EOS
end
