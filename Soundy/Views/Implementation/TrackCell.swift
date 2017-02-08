//
//  TrackCell.swift
//  Soundy
//
//  Created by Sendy Halim on 1/28/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class TrackCell: NSCollectionViewItem {
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var artworkImageView: NSImageView!
  @IBOutlet weak var playButton: NSButton!

  var disposeBag = DisposeBag()

  func setup(withViewModel viewModel: TrackViewModelType) {
    disposeBag = DisposeBag()

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
}
