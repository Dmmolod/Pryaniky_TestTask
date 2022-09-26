//
//  VideoTableCellViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 24.09.2022.
//

import AVFoundation

class VideoTableCellViewModel: VideoTableCellViewModelProtocol {
    
    var videoPlayerUpdateCallBack: ((AVPlayer?) -> Void)? {
        didSet { videoPlayerUpdateCallBack?(videoPlayer) }
    }
    var videoTextCallBack: ((String) -> Void)? {
        didSet { videoTextCallBack?(videoText) }
    }
    
    private var videoPlayer: AVPlayer?
    private var videoText: String
    private var mediaURL: URL?
    private var coverURL: URL?
    
    init(model: VideoModel) {
        self.videoText = model.text
        self.mediaURL = URL(string: model.mediaURLString)
        self.coverURL = URL(string: model.coverURLString)
        
        updateState()
    }
    
    private func updateState() {
        videoTextCallBack?(videoText)
        guard let mediaURL = mediaURL else { return }
        videoPlayer = AVPlayer(url: mediaURL)
        videoPlayerUpdateCallBack?(videoPlayer)
        videoPlayer?.volume = 0
        videoPlayer?.play()
    }
}
