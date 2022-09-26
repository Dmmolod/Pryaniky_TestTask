//
//  VideoTableViewCell.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 24.09.2022.
//
import UIKit
import AVKit

class VideoTableCellView: UITableViewCell {
    
    var viewModel: VideoTableCellViewModelProtocol?
    
    private let videoPlayerView = VideoPlayerView()
    private let videoTextLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        applyConstraints()
        spinner.startAnimating()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind() {
        viewModel?.videoPlayerUpdateCallBack = { videoPlayer in
            self.videoPlayerView.player = videoPlayer
        }
        
        viewModel?.videoTextCallBack = { text in
            self.videoTextLabel.text = text
        }
    }
    
    private func setupUI() {
        for subview in [spinner, videoTextLabel, videoPlayerView] {
            contentView.addSubview(subview)
        }
        videoTextLabel.textAlignment = .center
    }
    
    private func applyConstraints() {
        for customView in [spinner, videoTextLabel, videoPlayerView] {
            customView.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            videoTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            videoTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            videoTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            videoPlayerView.topAnchor.constraint(equalTo: videoTextLabel.bottomAnchor, constant: 10),
            videoPlayerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            videoPlayerView.heightAnchor.constraint(equalToConstant: 200),
            videoPlayerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            videoPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            spinner.topAnchor.constraint(equalTo: videoPlayerView.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: videoPlayerView.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: videoPlayerView.trailingAnchor)
        ])
    }
}
