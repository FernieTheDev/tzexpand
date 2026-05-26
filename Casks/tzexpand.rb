cask "tzexpand" do
  version "0.4.0"
  sha256 "a29f76019fb6a8860f08b1d9151105c9bdb1c07f4344be58ac0b7f76f0412a2e"

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
