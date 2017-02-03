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

struct TrackViewModel: TrackViewModelType {
  let track: Variable<Track>

  ///  MARK: Output
  var title: Driver<String> {
    return track.asDriver().map { $0.title }
  }

  var artworkURL: Driver<URL> {
    return track.asDriver().map { $0.artworkURL }
  }
  
  init(track: Track) {
    self.track = Variable<Track>(track)
  }

  func togglePlay() {
     
  }

  func play() {
    
  }

  func pause() {
    
  }

  func stop() {
    
  }
}
