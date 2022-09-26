//
//  AudioTableCellViewModelProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 26.09.2022.
//

import Foundation

protocol AudioTableCellViewModelProtocol {
    
    var spinnerIsActive: ((Bool) -> Void)? { get set }
    var playerIsPlaying: ((Bool) -> Void)? { get set }
    var coverImageUpdateCallBack: ((Data) -> Void)? { get set }
    var audioTextUpdateCallBack: ((String) -> Void)? { get set }
    
    func playButtonPressed()
}
