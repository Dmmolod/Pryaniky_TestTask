//
//  NetworkModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

struct ServerResponse: Decodable {
    let data: [ResponseData]
    let view: [String]
}

enum ResponseDataType: String, Decodable {
    case picture
    case selector
    case hz
    case unknown
    
    init(from decoder: Decoder) throws {
        let type = try decoder.singleValueContainer().decode(String.self)
        self = ResponseDataType(rawValue: type) ?? .unknown
    }
}

enum ResponseData: Decodable {
    case picture(PictureBlock)
    case selector(SelectorBlock)
    case hz(TextBlock)
    case unknown
    
    var type: ResponseDataType {
        switch self {
        case .picture: return .picture
        case .selector: return .selector
        case .hz: return .hz
        case .unknown: return .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try? container.decode(ResponseDataType.self, forKey: .name) else {
            self = .unknown
            return
        }
        
        let objectContainer = try decoder.singleValueContainer()
        
        switch type {
        case .picture:
            let pictureBlock = try objectContainer.decode(PictureBlock.self)
            self = .picture(pictureBlock)
        case .selector:
            let selectorBlock = try objectContainer.decode(SelectorBlock.self)
            self = .selector(selectorBlock)
        case .hz:
            let textBlock = try objectContainer.decode(TextBlock.self)
            self = .hz(textBlock)
        case .unknown: self = .unknown
        }
    }
}

struct Text: Decodable {
    let text: String
}

struct Picture: Decodable {
    let text: String
    let url: String
}

struct Variant: Decodable {
    var id: Int
    let text: String
}

struct Selector: Decodable {
    let selectedId: Int
    let variants: [Variant]
}

struct TextBlock: Decodable {
    let name: String
    let data: Text
}

struct PictureBlock: Decodable {
    let name: String
    let data: Picture
}

struct SelectorBlock: Decodable {
    let name: String
    let data: Selector
}
