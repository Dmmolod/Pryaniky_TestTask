//
//  VideoPlayerView.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.09.2022.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            (layer as? AVPlayerLayer)?.player
        }
        
        set {
            (layer as? AVPlayerLayer)?.player = newValue
        }
    }
}
