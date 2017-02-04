//
//  ViewController.swift
//  Soundy
//
//  Created by Sendy Halim on 12/17/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Cartography
import RxSwift

class RootViewController: NSViewController {
  var trackCollectionVC: TrackCollectionViewController!
  let vm = TrackCollectionViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    trackCollectionVC = TrackCollectionViewController(viewModel: vm)

    view.addSubview(trackCollectionVC.view)

    constrain(view, trackCollectionVC.view) { parent, child in
      child.top == parent.top
      child.bottom == parent.bottom
      child.right == parent.right
      child.left == parent.left
    }
  }
}
