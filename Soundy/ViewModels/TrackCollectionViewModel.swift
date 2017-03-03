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
  func loadMore()
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
        TrackViewModel.init <^> tracks |> List.init
      }
      .bindTo(_viewModels)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func loadMore() {
//    let user = User(
//      id: 300,
//      avatarURL: URL(string: "https://avatars1.githubusercontent.com/u/3948217?v=3&s=460")!,
//      profileURL: URL(string: "https://github.com/sendyhalim")!,
//      username: "test username"
//    )
//    let track = Track(
//      id: 100,
//      user: user,
//      title: "test track",
//      artworkURL: nil,
//      streamURL: URL(string: "https://i1.sndcdn.com/artworks-000118272430-2uofaw-large.jpg")!,
//      waveformURL: URL(string: "https://w1.sndcdn.com/Pm8iUvAq0PCl_m.png")!,
//      duration: 238076,
//      playbackCount: 100
//    )
//
//    let vm = TrackViewModel(track: track)
//
//    _viewModels.value = _viewModels.value.append(List(arrayLiteral: vm))
  }
}
