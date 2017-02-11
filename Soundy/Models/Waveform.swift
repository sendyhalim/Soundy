import Foundation
import Argo
import Runes
import Curry

struct Waveform {
  let barHeights: [Double]
}

///  Calculate average bar heights of a track
///
///  - parameter range:      Size of each cluster
///  - parameter barHeights: Array of bar heights in `Double`
///
///  - returns: Average bar heights
func averageBarHeights(range: Int, barHeights: [Double]) -> [Double] {
  var rangeCounter = 0
  var ranges: [ClosedRange<Int>] = []

  while rangeCounter < barHeights.count {
    var upperBound = rangeCounter + range - 1

    if upperBound > (barHeights.count - 1) {
      upperBound = barHeights.count - 1
    }

    ranges.append(rangeCounter...upperBound)
    rangeCounter += range
  }

  return ranges.map {
    (barHeights[$0].reduce(0, (+)) / Double($0.count)) * Config.Track.maxBarHeight
  }
}

extension Waveform: Decodable {
  static func decode(_ json: JSON) -> Decoded<Waveform> {
    return [Double].decode(json)
      .map(curry(averageBarHeights)(Config.Track.barClusterSize))
      .map(Waveform.init)
  }
}
