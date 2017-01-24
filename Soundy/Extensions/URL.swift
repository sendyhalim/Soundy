import Foundation
import Argo

extension URL: Decodable {
  public static func decode(_ json: JSON) -> Decoded<URL> {
    switch json {
    case .string(let str):
      return URL(string: str).map(pure) ?? .typeMismatch(expected: "\(str) is not a valid URL!", actual: json)
    default:
      return .typeMismatch(expected: "String", actual: json)
    }
  }
}
