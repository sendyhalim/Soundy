import AppKit
import RxCocoa
import RxSwift

class TrackCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let collectionViewModel: TrackCollectionViewModelType
  var disposeBag = DisposeBag()

  init(viewModel: TrackCollectionViewModelType) {
    self.collectionViewModel = viewModel

    super.init(nibName: "TrackCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self

    setupBindings()
    collectionViewModel.search(term: "oh wonder").addDisposableTo(disposeBag)
  }

  func setupBindings() {
    disposeBag = DisposeBag()

    collectionViewModel
      .reload
      .drive(onNext: collectionView.reloadData)
      .addDisposableTo(disposeBag)
  }
}

extension TrackCollectionViewController: NSCollectionViewDataSource {
  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return collectionViewModel.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let trackViewModel = collectionViewModel.viewModel(at: indexPath.item)
    let cell = collectionView.makeItem(
      withIdentifier: "TrackCell",
      for: indexPath
    ) as! TrackCell

    cell.setup(withViewModel: trackViewModel)

    return cell
  }
}