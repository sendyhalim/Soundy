import Foundation
import RxSwift
import RxCocoa
import Swiftz

protocol TrackCollectionViewModelType {
  var reload: Driver<Void> { get }
  var fetching: Driver<Bool> { get }
  var count: Int { get }

  func viewModel(at index: Int) -> TrackViewModelType
  func search(term: String) -> Disposable
}

struct TrackCollectionViewModel: TrackCollectionViewModelType {
  // MARK: Output
  var reload: Driver<Void> {
    return _viewModels
      .asDriver()
      .map(const(Void()))
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  var count: Int {
    return _viewModels.value.count
  }

  // MARK: Input
  let _fetching: Variable<Bool> = Variable(false)
  let _viewModels: Variable<List<TrackViewModel>> = Variable(List())

  func viewModel(at index: Int) -> TrackViewModelType {
    return _viewModels.value[UInt(index)]
  }

  func search(term: String) -> Disposable {
    let request = Soundcloud.request(api: .searchTracks(term)).share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: true)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(Track.self, withRootKey: "collection")
      .map { tracks in
        { TrackViewModel(track: $0, musicPlayer: AVMusicPlayer.sharedPlayer) } <^> tracks |> List.init
      }
      .bindTo(_viewModels)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }
}
