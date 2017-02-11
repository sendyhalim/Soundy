import AppKit
import RxSwift

///  Calculates x offset for bar at the given index
///
///  - parameter index: Bar view index (zero based)
///
///  - returns: x offset
func xPositionForBar(at index: Int) -> CGFloat {
  return CGFloat(Config.Track.barWidth + Config.Track.barRange) * CGFloat(index)
}

///  Create a bar view, its x position will be automatically calculated based on the given index.
///
///  - parameter index:  Bar view position (zero based)
///  - parameter height: Bar view height
///
///  - returns: Bar view
func barView(at index: Int, height: Double) -> NSView {
  let bar = NSView(frame: NSRect(x: 0, y: 0, width: Config.Track.barWidth, height: height))
  let origin = NSPoint(x: xPositionForBar(at: index), y: bar.frame.origin.y)

  bar.setFrameOrigin(origin)
  bar.wantsLayer = true
  bar.layer!.backgroundColor = Config.Track.barOffColor.cgColor

  return bar
}

class TrackCell: NSCollectionViewItem {
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var artworkImageView: NSImageView!
  @IBOutlet weak var playButton: NSButton!
  @IBOutlet weak var barContainerView: NSBox!

  var disposeBag = DisposeBag()

  override func awakeFromNib() {
    super.awakeFromNib()

    for i in 0..<300 {
      barContainerView.addSubview(barView(at: i, height: 0))
    }
  }

  func setup(withViewModel viewModel: TrackViewModelType) {
    disposeBag = DisposeBag()

    barContainerView.isHidden = true

    viewModel
      .waveformData
      .drive(onNext: updateWaveformView)
      .addDisposableTo(disposeBag)

    viewModel
      .title
      .drive(titleTextField.rx.text.orEmpty)
      .addDisposableTo(disposeBag)

    viewModel
      .artworkURL
      .drive(onNext: artworkImageView.setImage)
      .addDisposableTo(disposeBag)

    playButton
      .rx.tap
      .subscribe(onNext: viewModel.togglePlay)
      .addDisposableTo(disposeBag)
  }

  func updateWaveformView(waveform: Waveform) {
    for i in 0..<waveform.barHeights.count {
      let view = barContainerView.contentView!.subviews[i]
      view.frame.size.height = CGFloat(waveform.barHeights[i])
    }

    barContainerView.isHidden = false
  }
}
