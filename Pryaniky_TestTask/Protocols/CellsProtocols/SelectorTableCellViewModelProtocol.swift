//
//  SelectorTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol SelectorTableCellViewModelProtocol {
    
    var delegate: SelectorTableCellViewModelDelegate? { get set }
    
    var textIsUpdateCallBack: ((String) -> Void)? { get set }
    var updates: (([SelectorModel.VariantModel], Int?) -> Void)? { get set }
    
    func getStartIndex() -> Int?
    func segmentIsSelected(at segmentId: Int)
}
