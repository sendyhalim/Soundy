import AppKit
import RxSwift

///  Calculates x offset for bar at the given index
///
///  - parameter index: Bar view index (zero based)
///
///  - returns: x offset
func xPositionForBar(at index: Int) -> Double {
  return (Config.Track.barWidth + Config.Track.barRange) * Double(index)
}

///  Create a bar layer, its x position will be automatically calculated based on the given index.
///
///  - parameter index:  Bar view position (zero based)
///  - parameter height: Bar view height
///
///  - returns: Bar layer
func barLayer(at index: Int, height: Double) -> CALayer {
  let bar = CALayer()
  bar.backgroundColor = Config.Track.barOffColor.cgColor
  bar.frame = NSRect(
    x: xPositionForBar(at: index),
    y: Double(bar.frame.origin.y),
    width: Config.Track.barWidth,
    height: height
  )

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
    barContainerView.contentView!.wantsLayer = true

    for i in 0..<300 {
      barContainerView.contentView!.layer!.addSublayer(barLayer(at: i, height: 0))
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
    let bars = barContainerView.contentView!.layer!.sublayers!

    for i in 0..<waveform.barHeights.count {
      bars[i].frame.size.height = CGFloat(waveform.barHeights[i])
    }

    barContainerView.isHidden = false
  }
}
