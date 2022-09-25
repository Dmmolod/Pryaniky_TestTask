//
//  AudioTableCellViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 24.09.2022.
//

import AVFoundation

class AudioTableCellViewModel: AudioTableCellViewModelProtocol {
    
    var spinnerIsActive: ((Bool) -> Void)? {
        didSet { spinnerIsActive?(true) }
    }
    var playerIsPlaying: ((Bool) -> Void)?
    var audioTextUpdateCallBack: ((String) -> Void)? {
        didSet { audioTextUpdateCallBack?(audioText) }
    }
    var coverImageUpdateCallBack: ((Data) -> Void)? {
        didSet { loadCover() }
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var audioText: String
    private var audioURL: URL?
    private var coverURL: URL?
    
    init(model: AudioModel) {
        audioText = model.text
        audioURL = URL(string: model.mediaURLString)
        coverURL = URL(string: model.coverURLString)
        updateState()
    }
    
    private func updateState() {
        audioTextUpdateCallBack?(audioText)
        loadPlayer()
        loadCover()
    }
    
    private func loadPlayer() {
        guard let audioURL = audioURL else { return }
        
        self.spinnerIsActive?(true)
        URLSession.shared.dataTask(with: audioURL) { [weak self] data, _, error in
            guard let data = data,
                  audioURL == self?.audioURL,
                  let player = try? AVAudioPlayer(data: data) else { return }
            self?.audioPlayer = player
            DispatchQueue.main.async {
                self?.spinnerIsActive?(false)
            }
        }.resume()
    }
    
    private func loadCover() {
        guard let coverURL = coverURL else { return }
        
        URLSession.shared.dataTask(with: coverURL) { [weak self] data, _, error in
            guard let data = data, coverURL == self?.coverURL else { return }
            DispatchQueue.main.async {
                self?.coverImageUpdateCallBack?(data)
            }
        }.resume()
    }
    
    func playButtonPressed() {
        guard let audioPlayer = audioPlayer else { return }
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            playerIsPlaying?(false)
        } else {
            audioPlayer.play()
            playerIsPlaying?(true)
        }
    }
}
