cask "tzexpand" do
  version "0.4.2"
  sha256 "82136ca90759b7990816d1186ee74478685de202cd54e8f8f355dcd37cb9bfe0"

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
