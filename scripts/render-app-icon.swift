import AppKit
import SwiftUI

@main
struct RenderAppIcon {
    @MainActor
    static func main() throws {
        let iconset = URL(fileURLWithPath: CommandLine.arguments[1])
        try FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)
        guard let artwork = NSImage(contentsOfFile: CommandLine.arguments[2]) else { throw CocoaError(.fileReadCorruptFile) }
        for points in [16, 32, 128, 256, 512] {
            for scale in [1, 2] {
                let renderer = ImageRenderer(content: AppIcon(size: CGFloat(points * scale), artwork: artwork))
                guard let image = renderer.cgImage,
                      let png = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:])
                else { throw CocoaError(.fileWriteUnknown) }
                try png.write(to: iconset.appending(path: "icon_\(points)x\(points)\(scale == 2 ? "@2x" : "").png"))
            }
        }
    }
}

struct AppIcon: View {
    let size: CGFloat
    let artwork: NSImage

    var body: some View {
        let tile = size * 824 / 1024
        Image(nsImage: artwork)
            .resizable()
            .interpolation(.high)
            .frame(width: tile, height: tile)
            .clipShape(RoundedRectangle(cornerRadius: tile * 0.225, style: .continuous))
            .compositingGroup()
            .shadow(color: .black.opacity(0.25), radius: size * 10 / 1024, y: size * 6 / 1024)
            .frame(width: size, height: size)
            .environment(\.colorScheme, .light)
    }
}
