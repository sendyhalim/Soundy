import AppKit
import RxCocoa
import RxSwift

class TrackCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var searchTextField: NSTextField!
  @IBOutlet weak var trackPlayerContainer: NSBox!

  let collectionViewModel: TrackCollectionViewModelType
  var disposeBag = DisposeBag()
  var trackPlayerVC: TrackPlayerController?

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
    collectionView.delegate = self

    setupBindings()
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    collectionView.collectionViewLayout?.invalidateLayout()

  }

  func setupBindings() {
    disposeBag = DisposeBag()

    collectionViewModel
      .reload
      .drive(onNext: collectionView.reloadData)
      .addDisposableTo(disposeBag)

    searchTextField
      .rx.text.orEmpty
      .filter { $0.characters.count > 3 }
      .throttle(1.0, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] term in
        guard let `self` = self else {
          return
        }

        self.collectionViewModel.search(term: term).addDisposableTo(self.disposeBag)
      })
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
    cell.delegate = self

    return cell
  }
}

extension TrackCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> NSSize {
    return CGSize(width: collectionView.bounds.width, height: 70)
  }
}

extension TrackCollectionViewController: TrackCellDelegate {
  func playButtonToggled(viewModel: TrackViewModelType) {
    trackPlayerVC = TrackPlayerController(viewModel: viewModel)
    trackPlayerContainer.contentView?.addSubview(trackPlayerVC!.view)
    trackPlayerContainer.isHidden = false
  }
}
