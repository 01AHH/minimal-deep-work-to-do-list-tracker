#!/bin/bash
# Build "Deep Work.app" — a minimal native macOS wrapper around index.html.
# Requires the Xcode command line tools (swiftc). Run: ./build.sh
set -e
cd "$(dirname "$0")"

APP="Deep Work.app"

# Refresh bundled web assets
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

# Write the bundle's Info.plist
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key>
	<string>Deep Work</string>
	<key>CFBundleDisplayName</key>
	<string>Deep Work</string>
	<key>CFBundleIdentifier</key>
	<string>local.deepwork.session</string>
	<key>CFBundleVersion</key>
	<string>1.0</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleExecutable</key>
	<string>DeepWork</string>
	<key>CFBundleIconFile</key>
	<string>AppIcon</string>
	<key>LSMinimumSystemVersion</key>
	<string>11.0</string>
	<key>NSHighResolutionCapable</key>
	<true/>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
</dict>
</plist>
PLIST

cp index.html "$APP/Contents/Resources/index.html"
rm -rf "$APP/Contents/Resources/fonts"
cp -R fonts "$APP/Contents/Resources/fonts"

# Build the app icon (circle being ticked off) and bundle it
swiftc gen_icon.swift -o /tmp/deepwork_gen_icon -framework AppKit
/tmp/deepwork_gen_icon AppIcon.iconset
iconutil -c icns AppIcon.iconset -o AppIcon.icns
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

# Compile the Swift binary
swiftc main.swift -o "$APP/Contents/MacOS/DeepWork" -framework Cocoa -framework WebKit

# Ad-hoc code sign so macOS will launch it locally
codesign --force --deep --sign - "$APP"

echo "Built '$APP'. Open it with:  open \"$APP\""
