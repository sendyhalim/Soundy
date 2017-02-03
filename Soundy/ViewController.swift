//
//  ViewController.swift
//  Soundy
//
//  Created by Sendy Halim on 12/17/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class RootViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let vm: TrackCollectionViewModelType = TrackCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self

    vm.reload
      .drive(onNext: collectionView.reloadData)
      .addDisposableTo(disposeBag)

    vm.search(term: "Oh Wonder").addDisposableTo(disposeBag)
  }

  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
}

extension RootViewController: NSCollectionViewDataSource {
  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: "TrackCell",
      for: indexPath
    ) as! TrackCell

    let viewModel = vm.viewModel(at: indexPath.item)
    cell.setup(withViewModel: viewModel)

    return cell
  }
}
