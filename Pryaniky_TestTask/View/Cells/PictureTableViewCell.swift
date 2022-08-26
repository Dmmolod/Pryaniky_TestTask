//
//  PictureTableViewCell.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

final class PictureTableViewCell: UITableViewCell {
    
    var viewModel: PictureTableCellViewModelProtocol?
    
    private let picture: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let textLable: UILabel = {
       let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind() {
        viewModel?.textIsUpdateCallBack = { [weak self] text in
            self?.textLable.text = text
        }
        viewModel?.pictureIsUpdateCallBack = { [weak self] picture in
            self?.picture.image = picture
        }
    }
    
    private func setupUI() {
        contentView.addSubview(picture)
        contentView.addSubview(textLable)
        
        picture.translatesAutoresizingMaskIntoConstraints = false
        textLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           picture.topAnchor.constraint(equalTo: contentView.topAnchor),
           picture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           picture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           picture.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            textLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLable.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 20),
            textLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
