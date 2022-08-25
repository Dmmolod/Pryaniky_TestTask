//
//  PictureTableCellViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

final class PictureTableCellViewModel: PictureTableCellViewModelProtocol {
    
    private var ImageService: ImageServiceProtocol
    
    var pictureIsUpdateCallBack: ((UIImage?) -> Void)? {
        didSet { updatePicture() }
    }
    var textIsUpdateCallBack: ((String) -> Void)? {
        didSet { textIsUpdateCallBack?(text) }
    }
    
    private var pricture: UIImage?
    private var pictureURLString: String
    private var text: String
    
    init(with imageService: ImageServiceProtocol, text: String, pictureURLString: String) {
        self.ImageService = imageService
        self.text = text
        self.pictureURLString = pictureURLString
    }
    
    private func updatePicture() {
        ImageService.fetchImage(for: pictureURLString) { [weak self] result in
            switch result {
            case .success(let picture):
                self?.pricture = picture
                self?.pictureIsUpdateCallBack?(picture)
            case .failure(let error): print(error)
            }
        }
    }
}
