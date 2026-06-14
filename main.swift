import Cocoa
import WebKit

class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
    var window: NSWindow!
    var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 760, height: 880)
        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Deep Work"
        window.center()
        window.setFrameAutosaveName("DeepWorkWindow")

        // Minimal chrome: transparent title bar, hidden title, cream backdrop
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = NSColor(red: 0.980, green: 0.976, blue: 0.965, alpha: 1.0)
        window.isMovableByWindowBackground = true

        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: rect, configuration: config)
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground") // let cream show through
        webView.allowsBackForwardNavigationGestures = false
        window.contentView = webView

        // Load the bundled HTML, granting read access to Resources (for fonts)
        if let res = Bundle.main.resourceURL {
            let html = res.appendingPathComponent("index.html")
            webView.loadFileURL(html, allowingReadAccessTo: res)
        }

        window.makeKeyAndOrderFront(nil)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Minimal menu so Cmd-Q, Cmd-W, fullscreen, copy/paste work
let menu = NSMenu()
let appMenuItem = NSMenuItem()
menu.addItem(appMenuItem)
let appMenu = NSMenu()
appMenu.addItem(withTitle: "Hide Deep Work", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
appMenu.addItem(NSMenuItem.separator())
appMenu.addItem(withTitle: "Quit Deep Work", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
appMenuItem.submenu = appMenu

let editMenuItem = NSMenuItem()
menu.addItem(editMenuItem)
let editMenu = NSMenu(title: "Edit")
editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
editMenu.addItem(NSMenuItem.separator())
editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
editMenuItem.submenu = editMenu

let viewMenuItem = NSMenuItem()
menu.addItem(viewMenuItem)
let viewMenu = NSMenu(title: "View")
viewMenu.addItem(withTitle: "Enter Full Screen", action: #selector(NSWindow.toggleFullScreen(_:)), keyEquivalent: "f")
viewMenuItem.submenu = viewMenu

let windowMenuItem = NSMenuItem()
menu.addItem(windowMenuItem)
let windowMenu = NSMenu(title: "Window")
windowMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
windowMenuItem.submenu = windowMenu

app.mainMenu = menu
app.run()
