//
//  TrackCollectionViewModelSpec.swift
//  Soundy
//
//  Created by Sendy Halim on 2/5/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Nimble
import OHHTTPStubs
import Quick
import RxSwift
import RxTest
import RxBlocking
import Swiftz

@testable import Soundy

class TrackCollectionViewModelSpec: QuickSpec {
  override func spec() {
    let scheduler = TestScheduler(initialClock: 0)
    let vm = TrackCollectionViewModel()
    let disposeBag = DisposeBag()
    let observer = scheduler.createObserver(List<TrackViewModel>.self)

    describe("TrackCollectionViewModel") {
      context(".search()") {
        beforeEach {
          // Stub http response
          stub(condition: { _ in true }) { _ in
            return OHHTTPStubsResponse(
              fileAtPath: OHPathForFile("tracks.fixture.json", type(of: self))!,
              statusCode: 200,
              headers: ["Content-Type": "application/json"]
            )
          }

          // Prepare bindings
          vm
            ._viewModels
            .asDriver()
            .drive(observer)
            .addDisposableTo(disposeBag)

          vm
            .search(term: "test for testing")
            .addDisposableTo(disposeBag)

          scheduler.start()
        }

        afterEach {
          OHHTTPStubs.removeAllStubs()
        }

        it("should emit 3 tracks") {
          expect(observer.events.last!.value.element!.count).toEventually(equal(3), timeout: 1)
        }
      }
    }
  }
}
