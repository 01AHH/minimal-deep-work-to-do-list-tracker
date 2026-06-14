# Minimal Deep Work To-Do List Tracker

A dead-simple, distraction-free to-do list for a single deep work session. Set
one intention, list a few concrete targets, check them off, and run an optional
session timer. Nothing else — no accounts, no sync, no notifications, no internet.

The UI is modeled on the look and feel of the
[Freewrite](https://www.freewrite.io/) writing app: cream background, the Lato
typeface, lots of whitespace, and a control bar that stays hidden until you need it.

![A minimal cream-coloured window with a session intention and a short checklist.](#)

## Two ways to run it

### 1. Just open the web file
Open `index.html` in any browser. That's it. Your session is saved locally in
the browser between visits.

### 2. Build the native macOS app (recommended)
A tiny native window with its own Dock icon and no browser chrome.

```bash
./build.sh
open "Deep Work.app"
```

Requires the Xcode command line tools (`xcode-select --install`). The app bundles
the HTML and fonts inside itself, so it is fully offline and you can move it
anywhere, including `/Applications`.

## How to use

- **Top line** — the one thing this session is for.
- **Targets** — press **Enter** to add the next one; click the **circle** to
  complete it; **Backspace** on an empty line removes it.
- **Bottom bar** (appears on hover):
  - **25:00** — click to start/stop the session timer; soft chime at zero.
    **Right-click** to change the length.
  - **clear done** — removes completed targets.
  - **new session** — wipes everything for a fresh start.
- **⌘F** fullscreen, **⌘W** close, **⌘Q** quit (native app).

## Files

| File | Purpose |
|------|---------|
| `index.html` | The entire app — markup, styles, and logic in one file. |
| `fonts/` | Lato (Light / Regular / Bold), loaded locally. |
| `main.swift` | Native macOS wrapper (a `WKWebView` hosting `index.html`). |
| `build.sh` | Compiles and signs `Deep Work.app`. |

## Notes

- The native app is **ad-hoc signed**, not notarized. It runs on your own Mac
  without fuss; copying it to another Mac will show a Gatekeeper warning.
- Data lives in the browser/WebView's local storage on your machine only.

## Licence

The Lato font is included under the SIL Open Font License. Everything else here
is free to use however you like.
