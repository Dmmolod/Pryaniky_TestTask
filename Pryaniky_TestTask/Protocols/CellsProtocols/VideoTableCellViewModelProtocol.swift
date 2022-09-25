//
//  VideoTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 26.09.2022.
//

import AVFoundation

protocol VideoTableCellViewModelProtocol {
    
    var videoPlayerUpdateCallBack: ((AVPlayer?) -> Void)? { get set }
    var videoTextCallBack: ((String) -> Void)? { get set }
}
