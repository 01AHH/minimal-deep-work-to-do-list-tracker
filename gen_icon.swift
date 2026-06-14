import AppKit

// Draws a minimal app icon: cream rounded-square background with a dark
// circle being "ticked off" by a checkmark. Outputs a full .iconset folder.

let ink = NSColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1)
let cream = NSColor(red: 0.980, green: 0.976, blue: 0.965, alpha: 1)

func renderPNG(_ size: CGFloat) -> Data {
    let px = Int(size)
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
        isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let cg = ctx.cgContext

    let full = CGRect(x: 0, y: 0, width: size, height: size)

    // Rounded-square background, inset slightly like a macOS app icon
    let inset = size * 0.085
    let bg = full.insetBy(dx: inset, dy: inset)
    let corner = bg.width * 0.235
    cg.addPath(CGPath(roundedRect: bg, cornerWidth: corner, cornerHeight: corner, transform: nil))
    cg.setFillColor(cream.cgColor)
    cg.fillPath()

    // Geometry for the circle + tick
    let cx = size / 2, cy = size / 2
    let r = size * 0.255
    let lineW = size * 0.052
    cg.setLineCap(.round)
    cg.setLineJoin(.round)
    cg.setStrokeColor(ink.cgColor)
    cg.setLineWidth(lineW)

    // The circle (open arc on the upper-right so the tick reads as "passing through")
    cg.addArc(center: CGPoint(x: cx, y: cy), radius: r,
              startAngle: .pi * 0.18, endAngle: .pi * 2 + .pi * 0.04, clockwise: false)
    cg.strokePath()

    // The checkmark (origin is bottom-left, so the vertex has the lowest y)
    cg.beginPath()
    cg.move(to: CGPoint(x: cx - r * 0.46, y: cy + r * 0.06))
    cg.addLine(to: CGPoint(x: cx - r * 0.06, y: cy - r * 0.34))
    cg.addLine(to: CGPoint(x: cx + r * 0.74, y: cy + r * 0.62))
    cg.strokePath()

    NSGraphicsContext.restoreGraphicsState()
    return rep.representation(using: .png, properties: [:])!
}

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon.iconset"
try? FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)

let specs: [(name: String, px: CGFloat)] = [
    ("icon_16x16.png", 16), ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32), ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128), ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256), ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512), ("icon_512x512@2x.png", 1024),
]
for s in specs {
    let data = renderPNG(s.px)
    try! data.write(to: URL(fileURLWithPath: out + "/" + s.name))
}
print("wrote \(specs.count) images to \(out)")
