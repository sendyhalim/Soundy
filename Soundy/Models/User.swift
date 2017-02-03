import Foundation
import Argo
import Curry
import Runes

struct User {
  let id: Int
  let avatarURL: URL
  let profileURL: URL
  let username: String
}

extension User: Decodable {
  static func decode(_ json: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> json <| "id"
      <*> json <| "avatar_url"
      <*> json <| "permalink_url"
      <*> json <| "username"
  }
}
