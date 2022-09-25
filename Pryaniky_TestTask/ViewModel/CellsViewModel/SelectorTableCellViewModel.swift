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
    
    var updates: (([SelectorModel.VariantModel], Int?) -> Void)? {
        didSet {
            updates?(variants, getStartIndex())
        }
    }
    
    var textIsUpdateCallBack: ((String) -> Void)? {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    private var selectedIndex: Int
    private var variants: [SelectorModel.VariantModel]
    private var text: String {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    init(_ selectedIndex: Int, _ variants: [SelectorModel.VariantModel]) {
        self.selectedIndex = selectedIndex
        self.variants = variants
        self.text = ""
        self.updateSelectedText(for: selectedIndex)
    }
    
    func getStartIndex() -> Int? {
        variants.firstIndex(where: { $0.id == selectedIndex })
    }
    
    func updateSelectedText(for index: Int) {
        guard index < variants.count else { return }
        self.text = variants.first(where: { $0.id == index })?.text ?? ""
    }
    
    func segmentIsSelected(at segmentId: Int) {
        guard segmentId < variants.count else { return }
        let selector = variants[segmentId]
        text = selector.text
        delegate?.selectorTableCellViewModelDidChange(selectId: selector.id, text: selector.text)
    }
}
