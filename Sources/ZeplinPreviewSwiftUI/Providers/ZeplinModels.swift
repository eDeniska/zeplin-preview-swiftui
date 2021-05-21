//
//  ZeplinModels.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation

struct ZeplinThumbnails: Decodable {
    let small: String
    let medium: String
    let large: String
}

struct ZeplinImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageLink = "original_url"
        case thumbnails = "thumbnails"
    }
    let imageLink: String
    let thumbnails: ZeplinThumbnails
}

struct ZeplinComponent: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "name"
        case details = "description"
        case image = "image"

    }
    let id: String
    let title: String
    let details: String?
    let image: ZeplinImage
}

struct ZeplinProject: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "name"
        case details = "description"
        case status = "status"
        case thumbnailLink = "thumbnail"
        case componentCount = "number_of_components"
        case screenCount = "number_of_screens"

    }
    let id: String
    let title: String
    let details: String?
    let status: String
    let thumbnailLink: String
    let componentCount: Int
    let screenCount: Int

    var isActive: Bool {
        status == "active"
    }
}
