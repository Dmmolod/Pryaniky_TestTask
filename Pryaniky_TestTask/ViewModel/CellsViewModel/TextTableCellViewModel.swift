//
//  TextTableCellViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

final class TextTableCellViewModel: TextTableCellViewModelProtocol {
    
    var textIsUpdateCallBack: ((String) -> Void)? {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    private var text: String {
        didSet {
            textIsUpdateCallBack?(text)
        }
    }
    
    init(with text: String) {
        self.text = text
    }
}
