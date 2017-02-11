import Nimble
import Quick
import Swiftz
@testable import Soundy

class WaveformSpec: QuickSpec {
  override func spec() {
    describe("private.averageBarHeights()") {
      let barHeights = [3.0, 10.0, 2.0, 3.0, 12.0, 7.0, 8.0, 2.0, 6.0]
      let normalizeExpectedBarHeights: ([Double]) -> [Double] = { heights in
        heights.map {
          ($0 * Config.Track.maxBarHeight).rounded()
        }
      }

      context("when range is 1") {
        it("should return unmodified bar heights") {
          expect(averageBarHeights(range: 1, barHeights: barHeights)) == normalizeExpectedBarHeights(barHeights)
        }
      }

      context("when range is 2") {
        it("should not calculate average of the last element") {
          let expected = normalizeExpectedBarHeights([6.5, 2.5, 9.5, 5.0, 6.0])

          expect(averageBarHeights(range: 2, barHeights: barHeights)) == expected
        }
      }

      context("when range is 3") {
        it("should uniformly calculate the average") {
          let expected = normalizeExpectedBarHeights([5.0, 7.33, 5.33])
          let results = averageBarHeights(range: 3, barHeights: barHeights).map {
            $0.rounded()
          }

          expect(results) == expected
        }
      }

      context("when range is taking all the the bar heights") {
        it("should calculate 1 average") {
          let results = averageBarHeights(range: 9, barHeights: barHeights).map {
            $0.rounded()
          }

          expect(results) == normalizeExpectedBarHeights([5.89])
        }
      }
    }
  }
}
