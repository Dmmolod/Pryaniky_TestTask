//
//  NetworkModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

enum ResponseDataType: String, Decodable {
    case picture
    case selector
    case hz
    case audio
    case video
    case unknown
    
    init(from decoder: Decoder) throws {
        let type = try decoder.singleValueContainer().decode(String.self)
        self = ResponseDataType(rawValue: type) ?? .unknown
    }
}

enum ResponseData: Decodable {
    case picture(PictureModel)
    case selector(SelectorModel)
    case hz(TextModel)
    case audio(AudioModel)
    case video(VideoModel)
    case unknown
    
    var type: ResponseDataType {
        switch self {
        case .picture: return .picture
        case .selector: return .selector
        case .hz: return .hz
        case .audio: return .audio
        case .video: return .video
        case .unknown: return .unknown
        }
    }

    enum CodingKeys: String, CodingKey {
        case name
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try? container.decode(ResponseDataType.self, forKey: .name) else {
            self = .unknown
            return
        }
                
        switch type {
        case .picture:
            let pictureModel = try container.decode(PictureModel.self, forKey: .data)
            self = .picture(pictureModel)
        case .selector:
            let selectorModel = try container.decode(SelectorModel.self, forKey: .data)
            self = .selector(selectorModel)
        case .hz:
            let textModel = try container.decode(TextModel.self, forKey: .data)
            self = .hz(textModel)
        case .audio:
            let audioModel = try container.decode(AudioModel.self, forKey: .data)
            self = .audio(audioModel)
        case .video:
            let videoModel = try container.decode(VideoModel.self, forKey: .data)
            self = .video(videoModel)
        case .unknown:
            self = .unknown
        }
    }
}

protocol ServerResponseProtocol {
    var data: [ResponseData] { get }
    var view: [ResponseDataType] { get }
}

struct PryanikyServerResponse: Decodable, ServerResponseProtocol {
    let data: [ResponseData]
    let view: [ResponseDataType]
}

struct AudioModel: Codable {
    let text: String
    let coverURLString: String
    let mediaURLString: String
    
    enum CodingKeys: String, CodingKey {
        case text, coverURLString = "coverUrl", mediaURLString = "mediaUrl"
    }
}

struct VideoModel: Codable {
    let text: String
    let urlString: String
    let coverURLString: String
    let mediaURLString: String
    
    enum CodingKeys: String, CodingKey {
        case text, urlString = "url", coverURLString = "coverUrl", mediaURLString = "mediaUrl"
    }
}

struct TextModel: Codable {
    let text: String
}

struct SelectorModel: Codable {
    
    struct VariantModel: Codable {
        let id: Int
        let text: String
    }
    
    let selectedId: Int
    let variants: [VariantModel]
}

struct PictureModel: Codable {
    let urlString: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url", text
    }
}
