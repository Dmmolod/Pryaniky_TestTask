//
//  SelectorTableViewCell.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

final class SelectorTableViewCell: UITableViewCell {
    
    var viewModel: SelectorTableCellViewModelProtocol?
        
    private let segmentedControll = UISegmentedControl()
    private let segmentTextLabel: UILabel = {
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
        viewModel?.variantsIsUpdateCallBack = { [weak self] variants in
            for (index, variant) in variants.enumerated() {
                
                self?.segmentedControll.insertSegment(action: UIAction { _ in
                    self?.viewModel?.segmentIsSelected(at: index)
                }, at: index, animated: true)
                
                self?.segmentedControll.setTitle("\(variant.id)", forSegmentAt: index)
            }
        }
        segmentedControll.selectedSegmentIndex = viewModel?.getStartIndex() ?? 0
        
        viewModel?.textIsUpdateCallBack = { [weak self] text in
            self?.segmentTextLabel.text = text
        }
    }
    
    private func setupUI() {
        contentView.addSubview(segmentedControll)
        contentView.addSubview(segmentTextLabel)
        
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControll.heightAnchor.constraint(equalToConstant: 50),
            segmentedControll.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedControll.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            segmentTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            segmentTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            segmentTextLabel.leadingAnchor.constraint(equalTo: segmentedControll.trailingAnchor, constant: 20),
            segmentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
