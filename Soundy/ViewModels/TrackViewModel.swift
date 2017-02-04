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
  let musicPlayer: MusicPlayer

  // MARK: Output
  var title: Driver<String> {
    return track.asDriver().map { $0.title }
  }

  var artworkURL: Driver<URL> {
    return track.asDriver().map { $0.artworkURL }
  }

  // MARK: Input

  init(track: Track, musicPlayer: MusicPlayer) {
    self.track = Variable<Track>(track)
    self.musicPlayer = musicPlayer
  }

  func togglePlay() {
    musicPlayer.play(track: track.value)
  }

  func play() {

  }

  func pause() {

  }

  func stop() {

  }
}
