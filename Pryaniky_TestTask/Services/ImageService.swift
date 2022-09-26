//
//  ImageService.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation
import UIKit

final class ImageService: ImageServiceProtocol {
    
    enum ImageServiceError: Error {
        case failedToGetURL
        case failedToGetData
        case failedToGetImage
    }
    
    private let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
    
    func fetchImage(for urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = fetchFromCache(urlString: urlString) { completion(.success(image)); return }
        
        loadPicture(for: urlString, completion: { result in
            switch result {
            case .success(let image): completion(.success(image))
            case .failure(let error): completion(.failure(error))
            }
        })
    }
    
    private func loadPicture(for urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(ImageServiceError.failedToGetURL))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ImageServiceError.failedToGetData))
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(ImageServiceError.failedToGetImage))
                }
                return
            }
            
            self?.saveToCache(image, with: urlString)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
    
    private func fetchFromCache(urlString: String) -> UIImage? {
        guard let cacheDir = cacheDir,
              let url = URL(string: urlString),
              let imageData = FileManager.default.contents(atPath: cacheDir.appendingPathComponent(url.lastPathComponent).path),
              let image = UIImage(data: imageData) else { return nil }
        
        return image
    }
    
    private func saveToCache(_ image: UIImage, with urlString: String) {
        guard let cacheDir = cacheDir,
              let url = URL(string: urlString) else { return }
        
        let imageData = image.pngData()
        
        FileManager.default.createFile(atPath: cacheDir.appendingPathComponent(url.lastPathComponent).path, contents: imageData)
    }
}
