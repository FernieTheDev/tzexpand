cask "tzexpand" do
  version "0.2.0"
  sha256 "3059ca0db416e907ba7ba67eff7032bc6ffc740ab5b46e7f747020f36790e7d6"

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
