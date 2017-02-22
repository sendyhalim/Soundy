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
  let duration: Double
  let playbackCount: Int
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
