//
//  MusicPlayer.swift
//  Soundy
//
//  Created by Sendy Halim on 1/27/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import AVFoundation
import Foundation

protocol MusicPlayer {
  var volume: Float { get set }
  func play(track: Track)
  func pause()
  func replay()
}

struct AVMusicPlayer {
  static let sharedPlayer = AVMusicPlayer()

  let player: AVPlayer = AVPlayer()
}

extension AVMusicPlayer: MusicPlayer {
  struct Time {
    static fileprivate let beginning = kCMTimeZero
  }

  var volume: Float {
    get {
      return player.volume
    }

    set {
      player.volume = volume
    }
  }

  func play(track: Track) {
    let streamURL = Soundcloud.streamURL(url: track.streamURL)
    let asset = AVURLAsset(url: streamURL)

    // We cannot use `AVPlayerItem(url:)` directly because it will load the audio stream synchronously
    asset.loadValuesAsynchronously(forKeys: ["playable"]) {
      let currentItem = AVPlayerItem(asset: asset)

      self.player.replaceCurrentItem(with: currentItem)
      self.player.play()
    }
  }

  func pause() {
    player.pause()
  }

  func replay() {
    player.seek(to: AVMusicPlayer.Time.beginning) { _ in
      self.player.play()
    }
  }
}
