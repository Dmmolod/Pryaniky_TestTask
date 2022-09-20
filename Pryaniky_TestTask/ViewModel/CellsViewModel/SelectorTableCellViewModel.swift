//
//  SelectorTableCellViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol SelectorTableCellViewModelDelegate: AnyObject {
    func selectorTableCellViewModelDidChange(selectId: Int, text: String)
}

final class SelectorTableCellViewModel: SelectorTableCellViewModelProtocol {
    
    weak var delegate: SelectorTableCellViewModelDelegate?
    
    var variantsIsUpdateCallBack: (([Variant]) -> Void)? {
        didSet { variantsIsUpdateCallBack?(variants) }
    }
    var textIsUpdateCallBack: ((String) -> Void)? {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    private let selectedIndex: Int
    private var variants: [Variant]
    private var text: String {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    init(_ selectedIndex: Int, _ variants: [Variant]) {
        self.selectedIndex = selectedIndex
        self.variants = variants
        
        self.text = variants.first(where: { variant in
            variant.id == selectedIndex
        })?.text ?? ""
    }
    
    func getStartIndex() -> Int? {
        variants.firstIndex(where:  {
            $0.id == selectedIndex
        })
    }
    
    func segmentIsSelected(at segmentId: Int) {
        guard segmentId < variants.count else { return }
        let selector = variants[segmentId]
        text = selector.text
        delegate?.selectorTableCellViewModelDidChange(selectId: selector.id, text: selector.text)
    }
}
