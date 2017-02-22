import AppKit
import Hue

struct Config {
  struct Icon {
    static let play: NSImage = #imageLiteral(resourceName: "Play")
    static let pause: NSImage = #imageLiteral(resourceName: "Pause")
  }

  struct Track {
    static let maxBarHeight = 40.0
    static let barClusterSize = 6
    static let barWidth = 1.5
    static let barRange = 0.5
    static let barOffColor = NSColor(hex: "#404552")
    static let barOnColor = NSColor(hex: "#1a75f0")
  }
}
