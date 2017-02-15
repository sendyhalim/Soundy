import AppKit
import Foundation
import RxSwift
import RxCocoa

protocol TrackViewModelType {
  var title: Driver<String> { get }
  var artworkURL: Driver<URL> { get }
  var waveformData: Driver<Waveform> { get }
  var barAnimation: Driver<CABasicAnimation> { get }

  func togglePlay() -> Driver<Int>
  func play() -> Driver<Int>
  func pause()
  func stop()
}

struct TrackViewModel: TrackViewModelType {
  let track: Variable<Track>
  let musicPlayer: MusicPlayer

  // MARK: Input
  private let _barAnimation = Variable<CABasicAnimation?>(nil)

  // MARK: Output
  var title: Driver<String> {
    return track.asDriver().map { $0.title }
  }

  var artworkURL: Driver<URL> {
    return track.asDriver().map { $0.artworkURL ?? Track.defaultArtworkURL }
  }

  var waveformData: Driver<Waveform> {
    return track.asDriver().flatMap {
      let api = WaveformAPI.waveformData($0.waveformURL)

      return WaveformData
        .request(api: api)
        .map(Waveform.self)
        .asDriver(onErrorJustReturn: Waveform(barHeights: []))
    }
  }

  var barAnimation: Driver<CABasicAnimation> {
    return _barAnimation
      .asDriver()
      .filter { $0 != nil }
      .map { $0! }
  }

   init(track: Track) {
    self.init(track: track, musicPlayer: AVMusicPlayer.sharedPlayer)
  }

  init(track: Track, musicPlayer: MusicPlayer) {
    self.track = Variable(track)
    self.musicPlayer = musicPlayer
  }

  func togglePlay() -> Driver<Int> {
    return play()
  }

  func play() -> Driver<Int> {
    return musicPlayer
      .play(track: track.value)
      .map {
        self.track.value.duration
      }
      .asDriver(onErrorJustReturn: 0)
  }

  func pause() {

  }

  func stop() {

  }
}
