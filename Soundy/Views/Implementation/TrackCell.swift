import AppKit
import RxSwift

protocol TrackCellDelegate: class {
  func playButtonToggled(viewModel: TrackViewModelType)
}

class TrackCell: NSCollectionViewItem {
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var durationTextField: NSTextField!
  @IBOutlet weak var artworkImageView: NSImageView!
  @IBOutlet weak var playButton: NSButton!

  weak var delegate: TrackCellDelegate?

  var disposeBag = DisposeBag()

  func setup(withViewModel viewModel: TrackViewModelType) {
    disposeBag = DisposeBag()

    viewModel
      .title
      .drive(titleTextField.rx.text.orEmpty)
      .addDisposableTo(disposeBag)

    viewModel
      .duration
      .drive(durationTextField.rx.text.orEmpty)
      .addDisposableTo(disposeBag)

    viewModel
      .artworkURL
      .drive(onNext: artworkImageView.setImage)
      .addDisposableTo(disposeBag)

    viewModel
      .playingIcon
      .drive(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        self.playButton.image = $0
      })
      .addDisposableTo(disposeBag)

    playButton
      .rx.tap
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        viewModel.togglePlay().addDisposableTo(self.disposeBag)
        self.delegate?.playButtonToggled(viewModel: viewModel)
      })
      .addDisposableTo(disposeBag)
  }
}
