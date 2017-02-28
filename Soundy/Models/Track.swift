import Foundation
import Argo
import Curry
import Runes

struct Track {
  static let defaultArtworkURL = URL(string: "https://github.com/identicons/github.png")!
  let id: Int
  let user: User
  let title: String
  let artworkURL: URL?
  let streamURL: URL
  let waveformURL: URL
  let duration: Duration
  let playbackCount: Int

  var waveform: Waveform?

  init(
    id: Int,
    user: User,
    title: String,
    artworkURL: URL?,
    streamURL: URL,
    waveformURL: URL,
    duration: Duration,
    playbackCount: Int
  ) {
    self.id = id
    self.user = user
    self.title = title
    self.artworkURL = artworkURL
    self.streamURL = streamURL
    self.waveformURL = waveformURL
    self.duration = duration
    self.playbackCount = playbackCount
  }
}

extension Track: Decodable {
  static func decode(_ json: JSON) -> Decoded<Track> {
    return curry(Track.init)
      <^> json <| "id"
      <*> json <| "user"
      <*> json <| "title"
      <*> json <|? "artwork_url"
      <*> json <| "stream_url"
      <*> json <| "waveform_url"
      <*> json <| "duration"
      <*> json <| "playback_count"
  }
}
