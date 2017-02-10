//
//  Waveform.swift
//  Soundy
//
//  Created by Sendy Halim on 2/10/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct Waveform {
  let barHeights: [Double]
}

func averageBarHeights(n: Int, barHeights: [Double]) -> [Double] {
  var rangeCounter = 0
  var ranges: [ClosedRange<Int>] = []

  while rangeCounter < barHeights.count {
    var upperBound = rangeCounter + n - 1

    if upperBound > (barHeights.count - 1) {
      upperBound = barHeights.count - 1
    }

    ranges.append(rangeCounter...upperBound)
    rangeCounter += n
  }

  return ranges.map { range in
    barHeights[range].reduce(0, (+)) / Double(range.count)
  }
}

extension Waveform: Decodable {
  static func decode(_ json: JSON) -> Decoded<Waveform> {
    return [Double].decode(json)
      .map(curry(averageBarHeights)(12))
      .map(Waveform.init)
  }
}
