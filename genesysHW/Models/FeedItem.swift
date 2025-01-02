//
//  FeedItem.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import Foundation

struct FeedItem: Decodable {
    let id: Int
    let description: String
    let thumbnail: String?
    
    private(set) var timestamp: Date
    private(set) var isCommand: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, description, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        thumbnail = try container.decode(String?.self, forKey: .thumbnail)
        timestamp = Date()
        isCommand = false
    }
    
    init(command: String) {
        self.id = Int.random(in: 1000...9999)
        self.description = command
        self.thumbnail = nil
        self.timestamp = Date()
        self.isCommand = true
    }
}

struct FeedResponse: Decodable {
    let products: [FeedItem]
}
