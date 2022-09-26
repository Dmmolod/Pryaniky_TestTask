//
//  ImageServiceProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 26.09.2022.
//

import UIKit

protocol ImageServiceProtocol {
    func fetchImage(for urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
