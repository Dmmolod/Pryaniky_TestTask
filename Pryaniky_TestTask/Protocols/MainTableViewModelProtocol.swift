//
//  MainTableViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol MainTableViewModelProtocol {
    var modelIsUpdateCallBack: (() -> Void )? { get set }
    var showAlertCallBack: ((String) -> Void)? { get set }

    func rowCount(in section: Int) -> Int
    func cellTypeForRow(at indexPath: IndexPath) -> ResponseData
    func viewModelForPictureCell(at indexPath: IndexPath) -> PictureTableCellViewModelProtocol?
    func viewModelForTextCell(at indexPath: IndexPath) -> TextTableCellViewModelProtocol?
    func viewModelForSelectorCell(at indexPath: IndexPath) -> SelectorTableCellViewModelProtocol?
    func didTapRow(at indexPath: IndexPath)
}
