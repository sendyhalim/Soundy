import AppKit
import Foundation
import RxSwift
import RxCocoa

protocol TrackViewModelType {
  var title: Driver<String> { get }
  var artworkURL: Driver<URL> { get }
  var waveformData: Driver<Waveform> { get }
  var barAnimation: Driver<CABasicAnimation> { get }
  var playingWithDuration: Driver<Double> { get }
  var durationLeft: Driver<Double> { get }
  var playerState: Driver<PlayerState> { get }
  var playingIcon: Driver<NSImage> { get }

  func togglePlay() -> Disposable
  func play() -> Disposable
  func pause() -> Disposable
  func stop()
}

struct TrackViewModel: TrackViewModelType {
  let track: Variable<Track>
  let musicPlayer: MusicPlayer

  // MARK: Input
  private let _barAnimation = Variable<CABasicAnimation?>(nil)
  private let _playerState = Variable<PlayerState>(.stopped)
  private let _playingIcon = Variable<NSImage>(Config.Icon.play)
  private let _durationLeft: Variable<Double>

  // MARK: Output
  var title: Driver<String> {
    return track.asDriver().map { $0.title }
  }

  var artworkURL: Driver<URL> {
    return track.asDriver().map { $0.artworkURL ?? Track.defaultArtworkURL }
  }

  var waveformData: Driver<Waveform> {
    return track.asDriver().flatMap {
      if self.track.value.waveform != nil {
        return Driver.just(self.track.value.waveform!)
      }

      let api = WaveformAPI.waveformData($0.waveformURL)

      let requestWaveformDataDriver = WaveformData
        .request(api: api)
        .map(Waveform.self)
        .asDriver(onErrorJustReturn: Waveform(barHeights: []))

      requestWaveformDataDriver
        .drive(onNext: { self.track.value.waveform = $0 })
        .addDisposableTo(self.disposeBag)

      return requestWaveformDataDriver
    }
  }

  var barAnimation: Driver<CABasicAnimation> {
    return _barAnimation
      .asDriver()
      .filter { $0 != nil }
      .map { $0! }
  }

  var durationLeft: Driver<Double> {
    return _durationLeft.asDriver()
  }

  var playerState: Driver<PlayerState> {
    return _playerState.asDriver()
  }

  var playingIcon: Driver<NSImage> {
    return _playingIcon.asDriver()
  }

  var playingWithDuration: Driver<Double> {
    return _playerState
      .asDriver()
      .filter { $0 == .playing }
      .flatMap { _ in self.durationLeft }
  }

  var disposeBag = DisposeBag()

  init(track: Track) {
    self.init(track: track, musicPlayer: AVMusicPlayer.sharedPlayer)
  }

  init(track: Track, musicPlayer: MusicPlayer) {
    self.track = Variable(track)
    self.musicPlayer = musicPlayer
    self._durationLeft = Variable(track.duration)

    let playerState = _playerState.asDriver()

    playerState
      .map {
        switch $0 {
          case .playing:
            return track.duration

          default:
            return 0
        }
      }
      .drive(_durationLeft)
      .addDisposableTo(disposeBag)

    playerState
      .map {
        switch $0 {
        case .playing:
          return Config.Icon.pause

        default:
          return Config.Icon.play
        }
      }
      .drive(_playingIcon)
      .addDisposableTo(disposeBag)
  }

  func togglePlay() -> Disposable {
    switch _playerState.value {
    case .playing:
      return pause()

    default:
      return play()
    }
  }

  func play() -> Disposable {
    return musicPlayer
      .play(track: track.value)
      .map {
        PlayerState.playing
      }
      .bindTo(_playerState)
  }

  func pause() -> Disposable {
    return musicPlayer
      .pause()
      .map {
        PlayerState.paused
      }
      .bindTo(_playerState)
  }

  func stop() {

  }
}
