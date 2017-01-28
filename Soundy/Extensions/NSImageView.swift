import AppKit
import Foundation
import Kingfisher

extension NSImageView {
  ///  Abstraction of Kingfisher `kf.setImage(with: Resource?)`
  ///
  ///  - parameter url: The image url
  func setImage(url: URL) {
    kf.setImage(with: url)
  }
}
