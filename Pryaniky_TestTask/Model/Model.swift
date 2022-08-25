//
//  NetworkModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

struct PryanikiResponse: Codable {
    let data: [ResponseType]?
    let view: [String]?
}

struct ResponseType: Codable {
    let name: String?
    var data: SomeData?
}

struct SomeData: Codable {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [Variant]?
}

struct Variant: Codable {
    let id: Int
    let text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}
