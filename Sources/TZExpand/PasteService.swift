import AppKit
import ApplicationServices

/// Replaces the focused element's selected text. Tries the AX
/// `kAXSelectedTextAttribute` write first (silent, no clipboard, works in
/// Electron apps like Slack that filter synthetic ⌘V), and falls back to
/// pasteboard + synthesized ⌘V for apps without AX text-replace support.
enum PasteService {
    static func paste(_ text: String) {
        if replaceSelectedTextViaAX(text) {
            NSLog("TZExpand: replaced via AX")
            return
        }
        NSLog("TZExpand: AX replace failed, falling back to ⌘V paste")
        pasteViaClipboard(text)
    }

    /// Returns true if AX successfully wrote the replacement text into the
    /// focused element's selection.
    private static func replaceSelectedTextViaAX(_ text: String) -> Bool {
        guard AXIsProcessTrusted() else { return false }
        let system = AXUIElementCreateSystemWide()
        var focused: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system,
                                            kAXFocusedUIElementAttribute as CFString,
                                            &focused) == .success,
              let element = focused else { return false }
        let axElement = element as! AXUIElement
        let err = AXUIElementSetAttributeValue(axElement,
                                               kAXSelectedTextAttribute as CFString,
                                               text as CFString)
        return err == .success
    }

    private static func pasteViaClipboard(_ text: String) {
        let pb = NSPasteboard.general
        let snapshot: [[NSPasteboard.PasteboardType: Data]] = pb.pasteboardItems?.compactMap { item in
            var dict: [NSPasteboard.PasteboardType: Data] = [:]
            for type in item.types {
                if let data = item.data(forType: type) {
                    dict[type] = data
                }
            }
            return dict.isEmpty ? nil : dict
        } ?? []

        pb.clearContents()
        pb.setString(text, forType: .string)
        synthesizeCmdV()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            pb.clearContents()
            for entry in snapshot {
                let item = NSPasteboardItem()
                for (type, data) in entry {
                    item.setData(data, forType: type)
                }
                pb.writeObjects([item])
            }
        }
    }

    private static func synthesizeCmdV() {
        let src = CGEventSource(stateID: .combinedSessionState)
        let v: CGKeyCode = 0x09
        let down = CGEvent(keyboardEventSource: src, virtualKey: v, keyDown: true)
        let up = CGEvent(keyboardEventSource: src, virtualKey: v, keyDown: false)
        down?.flags = .maskCommand
        up?.flags = .maskCommand
        down?.post(tap: .cghidEventTap)
        up?.post(tap: .cghidEventTap)
    }
}
