import Foundation
import RxSwift
import RxCocoa

protocol TrackViewModelType {
  var title: Driver<String> { get }
  var artworkURL: Driver<URL> { get }

  func togglePlay()
  func play()
  func pause()
  func stop()
}

struct TrackViewModel {

}
