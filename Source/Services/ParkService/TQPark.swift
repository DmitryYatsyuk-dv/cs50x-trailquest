//
// TQPark.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

struct TQPark: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let location: Location
    let imageURL: String
    let tags: [String]
    let checkpoints: [TQCheckpoint]

    enum CodingKeys: String, CodingKey {
        case id, name, description, location, tags, checkpoints
        case imageURL = "image_url"
    }
}
