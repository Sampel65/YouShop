//
//  NotificationItem.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//


import Foundation
struct NotificationItem: Identifiable, Codable {
    var id = UUID()
    let message: String
    let timestamp: Date
    var isRead: Bool  
    

    private enum CodingKeys: String, CodingKey {
        case id
        case message
        case timestamp
        case isRead
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(message, forKey: .message)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isRead, forKey: .isRead)
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID(uuidString: try container.decode(String.self, forKey: .id)) ?? UUID()
        self.message = try container.decode(String.self, forKey: .message)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
    }
    
    init(message: String, timestamp: Date, isRead: Bool) {
        self.message = message
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
