//
//  SelectorTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol SelectorTableCellViewModelProtocol {
    var variantsIsUpdateCallBack: (([Variant]) -> Void)? { get set }
    var textIsUpdateCallBack: ((String) -> Void)? { get set }
    
    func getStartIndex() -> Int
    func segmentIsSelected(at segmentId: Int) 
}
