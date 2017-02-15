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
  let containerLayer = CALayer()
  let bar = CALayer()
  let onBar = CALayer()

  bar.frame = CGRect(
    x: xPositionForBar(at: index),
    y: Double(bar.frame.origin.y),
    width: Config.Track.barWidth,
    height: height
  )

  onBar.backgroundColor = Config.Track.barOnColor.cgColor
  onBar.frame = bar.bounds

  bar.backgroundColor = Config.Track.barOffColor.cgColor
  bar.addSublayer(onBar)

  return containerLayer
}

func barShapeLayer(forView view: NSView, waveform: Waveform) -> CALayer {
  let layer = CAShapeLayer()
  let path = NSBezierPath(rect: view.bounds)

  layer.frame = view.bounds
  layer.fillRule = kCAFillRuleEvenOdd

  for i in (0 ..< waveform.barHeights.count) {
    let bar = NSBezierPath(rect: CGRect(
      x: xPositionForBar(at: i),
      y: Double(view.bounds.origin.y),
      width: Config.Track.barWidth,
      height: waveform.barHeights[i]
    ))

    path.append(bar)
  }

  layer.path = path.cgPath

  return layer
}

func barContainerLayer(forView view: NSView) -> CALayer {
  let containerLayer = CALayer()
  let offBackgroundLayer = CALayer()
  let onBackgroundLayer = CALayer()
  let frontContainerLayer = CALayer()

  containerLayer.frame = view.bounds
  offBackgroundLayer.backgroundColor = Config.Track.barOffColor.cgColor
  offBackgroundLayer.frame = containerLayer.bounds

  onBackgroundLayer.backgroundColor = Config.Track.barOnColor.cgColor
  onBackgroundLayer.frame = CGRect(
    x: -(containerLayer.bounds.midX),
    y: -(containerLayer.bounds.midY),
    width: containerLayer.bounds.size.width,
    height: containerLayer.bounds.size.height
  )
  onBackgroundLayer.anchorPoint = CGPoint.zero
  onBackgroundLayer.isHidden = true

  frontContainerLayer.backgroundColor = NSColor.white.cgColor
  frontContainerLayer.frame = containerLayer.bounds

  containerLayer.addSublayer(offBackgroundLayer)
  containerLayer.addSublayer(onBackgroundLayer)
  containerLayer.addSublayer(frontContainerLayer)

  return containerLayer
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
    barContainerView.contentView!.layer = barContainerLayer(forView: barContainerView.contentView!)
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
      .flatMap(viewModel.togglePlay)
      .subscribe(onNext: animateBarWidth)
      .addDisposableTo(disposeBag)
  }

  func updateWaveformView(waveform: Waveform) {
    let layer = barShapeLayer(forView: barContainerView.contentView!, waveform: waveform)
    let barLayers = barContainerView.contentView!.layer!.sublayers!
    barLayers.last!.mask = layer

    barContainerView.isHidden = false
  }

  func animateBarWidth(withDuration duration: Int) {
    let onBarLayer = barContainerView.contentView!.layer!.sublayers![1]
    let animation = CABasicAnimation(keyPath: "bounds.size.width")
    animation.duration = Double(duration) / 1000
    animation.fromValue = 0
    animation.toValue = barContainerView.frame.size.width

    onBarLayer.add(animation, forKey: nil)
    onBarLayer.isHidden = false
  }
}
