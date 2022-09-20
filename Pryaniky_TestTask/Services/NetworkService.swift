//
//  NetworkService.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch(completion: @escaping (Result<ServerResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private struct Constants {
        static let baseURL = "https://chat.pryaniky.com/json/data-custom-selected-id.json"
    }
    
    enum NetworkServiceError: Error {
        case failedToParseData
        case failedToGetURL
        case failedToGetData
    }
    
    func fetch(completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL) else { DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToGetURL)) } ;return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToGetData)) }
                return
            }
            
            if let serverResponse = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                DispatchQueue.main.async { completion(.success(serverResponse)) }
            } else { DispatchQueue.main.async { completion(.failure(NetworkServiceError.failedToParseData))} }
        }.resume()
    }
}
