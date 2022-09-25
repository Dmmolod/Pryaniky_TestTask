//
//  AudioTableCellView.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 24.09.2022.
//

import UIKit
import AVFoundation

class AudioTableCellView: UITableViewCell {
    
    var viewModel: AudioTableCellViewModelProtocol?
    
    private let coverImageView = UIImageView()
    private let audioTextLabel = UILabel()
    private let playButton = UIButton()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        setupUI()
        applyConstraints()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind() {
        viewModel?.coverImageUpdateCallBack = { imageData in
            self.coverImageView.image = UIImage(data: imageData)
        }
        
        viewModel?.playerIsPlaying = { isPlaying in
            let newImage = UIImage(systemName: isPlaying ? "pause.circle" : "play.circle")
            self.playButton.setImage(newImage, for: .normal)
        }
        
        viewModel?.spinnerIsActive = { isActive in
            if isActive {
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.playButton.isHidden = false
            }
        }
    }
    
    @objc private func playButtonPressed() {
        viewModel?.playButtonPressed()
    }
    
    private func setupUI() {
        for subview in [playButton, audioTextLabel, coverImageView, spinner] {
            contentView.addSubview(subview)
        }
        coverImageView.image = UIImage(systemName: "waveform")
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.tintColor = .systemPink
        
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.tintColor = .systemPink
        playButton.isHidden = true
        
        audioTextLabel.textAlignment = .center
    }
    
    private func applyConstraints() {
        for customView in [playButton, audioTextLabel, coverImageView, spinner] {
            customView.translatesAutoresizingMaskIntoConstraints = false
        }
        if let buttonImageView = playButton.imageView {
            buttonImageView.translatesAutoresizingMaskIntoConstraints = false
            buttonImageView.centerXAnchor.constraint(equalTo: playButton.centerXAnchor).isActive = true
            buttonImageView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
            buttonImageView.heightAnchor.constraint(equalTo: playButton.heightAnchor).isActive = true
            buttonImageView.widthAnchor.constraint(equalTo: playButton.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor, multiplier: 0.9),
            
            audioTextLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10),
            audioTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            audioTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            audioTextLabel.heightAnchor.constraint(equalToConstant: 40),
            
            playButton.topAnchor.constraint(greaterThanOrEqualTo: audioTextLabel.bottomAnchor,constant: 10),
            playButton.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            spinner.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            spinner.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            spinner.widthAnchor.constraint(equalTo: playButton.widthAnchor)
        ])
    }
}
