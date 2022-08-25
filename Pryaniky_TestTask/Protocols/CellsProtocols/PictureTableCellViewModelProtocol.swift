//
//  PictureTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

protocol PictureTableCellViewModelProtocol {
    var pictureIsUpdateCallBack: ((UIImage?) -> Void)? { get set }
    var textIsUpdateCallBack: ((String) -> Void)? { get set }
}
