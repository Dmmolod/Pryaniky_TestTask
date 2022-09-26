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
    
    private let imageService = ImageService()
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
        guard let urlString = coverURL?.absoluteString else { return }
        
        imageService.fetchImage(for: urlString) { result in
            switch result {
            case .success(let coverImage):
                if let imageData = coverImage.pngData() {
                    self.coverImageUpdateCallBack?(imageData)
                }
            case .failure(let failure): print(failure.localizedDescription)
            }
        }
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
