//
//  NetworkServiceProtocol.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 26.09.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch(urlString: String, completion: @escaping (Result<PryanikyServerResponse, Error>) -> Void)
}
