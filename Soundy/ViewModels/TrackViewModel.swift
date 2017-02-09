import Foundation
import RxSwift
import RxCocoa

protocol TrackViewModelType {
  var title: Driver<String> { get }
  var artworkURL: Driver<URL> { get }
  var waveformData: Driver<[Int]> { get }

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
    return track.asDriver().map { $0.artworkURL ?? Track.defaultArtworkURL }
  }

  var waveformData: Driver<[Int]> {
    return track.asDriver().flatMap {
      let api = WaveformAPI.waveformData($0.waveformURL)

      return Waveform
        .request(api: api)
        .mapArray(Int.self, withRootKey: nil)
        .asDriver(onErrorJustReturn: [])
    }
  }

   init(track: Track) {
    self.init(track: track, musicPlayer: AVMusicPlayer.sharedPlayer)
  }

  init(track: Track, musicPlayer: MusicPlayer) {
    self.track = Variable(track)
    self.musicPlayer = musicPlayer
  }

  func togglePlay() {
    play()
  }

  func play() {
    musicPlayer.play(track: track.value)
  }

  func pause() {

  }

  func stop() {

  }
}
