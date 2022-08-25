//
//  TextTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol TextTableCellViewModelProtocol {
    var textIsUpdateCallBack: ((String) -> Void)? { get set }
}
