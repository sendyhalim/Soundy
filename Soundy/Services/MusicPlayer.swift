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
    let currentItem = AVPlayerItem(url: track.streamURL)

    player.replaceCurrentItem(with: currentItem)
    player.play()
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
