import Argo
import Swiftz

struct Duration {
  let doubleValue: Double
}

extension Duration: CustomStringConvertible {
  var description: String {
    let minutes = Int(doubleValue / 60)
    let seconds = Int(doubleValue) % 60

    let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

    return "\(minutes):\(secondsString)"
  }
}

extension Duration: Decodable {
  static func decode(_ json: JSON) -> Decoded<Duration> {
    return Duration.init <^> { $0 / 1000 } <^> Double.decode(json)
  }
}
