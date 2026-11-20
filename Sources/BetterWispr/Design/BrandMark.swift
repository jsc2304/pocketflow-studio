import AppKit
import SwiftUI

struct BrandMark: View {
    var size: CGFloat = 34

    var body: some View {
        Image(nsImage: NSApplication.shared.applicationIconImage)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

enum BrandGlyph {
    /// The five rounded bars of the PocketFlow icon, fitted to a 17-point menu item.
    @MainActor static let menuBarImage: NSImage = {
        let size = NSSize(width: 17, height: 17)
        let heights: [CGFloat] = [4, 10, 15, 8.5, 3.75]
        let image = NSImage(size: size, flipped: false) { _ in
            NSColor.white.setFill()
            for (index, height) in heights.enumerated() {
                let rect = NSRect(x: CGFloat(index) * 3.6, y: (size.height - height) / 2,
                                  width: 2.6, height: height)
                NSBezierPath(roundedRect: rect, xRadius: 1.3, yRadius: 1.3).fill()
            }
            return true
        }
        image.isTemplate = true
        return image
    }()
}
