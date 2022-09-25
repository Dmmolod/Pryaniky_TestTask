//
//  NetworkService.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch(urlString: String, completion: @escaping (Result<PryanikyServerResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    struct Constants {
        static let longViewURL = "https://chat.pryaniky.com/json/data-default-order-very-very-long-view.json"
        static let moreItemsURL = "https://chat.pryaniky.com/json/data-custom-order-much-more-items-in-data.json"
        static let customData = "https://chat.pryaniky.com/json/data-default-order-custom-data-in-view.json"
    }
    
    enum NetworkServiceError: Error {
        case failedToParseData
        case failedToGetURL
        case failedToGetData
    }
    
    func fetch(urlString: String, completion: @escaping (Result<PryanikyServerResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else { DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToGetURL)) } ;return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToGetData)) }
                return
            }
            
            if let serverResponse = try? JSONDecoder().decode(PryanikyServerResponse.self, from: data) {
                DispatchQueue.main.async { completion(.success(serverResponse)) }
            } else { DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToParseData))} }
        }.resume()
    }
}
