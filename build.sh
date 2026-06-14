#!/bin/bash
# Build "Deep Work.app" — a minimal native macOS wrapper around index.html.
# Requires the Xcode command line tools (swiftc). Run: ./build.sh
set -e
cd "$(dirname "$0")"

APP="Deep Work.app"

# Refresh bundled web assets
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp index.html "$APP/Contents/Resources/index.html"
rm -rf "$APP/Contents/Resources/fonts"
cp -R fonts "$APP/Contents/Resources/fonts"

# Compile the Swift binary
swiftc main.swift -o "$APP/Contents/MacOS/DeepWork" -framework Cocoa -framework WebKit

# Ad-hoc code sign so macOS will launch it locally
codesign --force --deep --sign - "$APP"

echo "Built '$APP'. Open it with:  open \"$APP\""
