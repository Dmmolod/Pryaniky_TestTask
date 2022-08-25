//
//  TextTableViewCell.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

final class TextTableViewCell: UITableViewCell {
    
    var viewModel: TextTableCellViewModelProtocol?
    
    private var textLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    }
    
    private func setupUI() {
        contentView.addSubview(textLable)
        
        textLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
