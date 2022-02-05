//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Codable {
    // MARK: - Server Properties
    enum CodingKeys: String, CodingKey {
        case id, userIds, userImageURLs, saleItemId, messages
    }
    
    enum QueryKeys: String {
        case userIds
    }
    
    var id = UUID().uuidString
    let userIds: Set<String>
    var userImageURLs: Set<String>
    let saleItemId: String
    var messages: [Message] = []
    
    // MARK: - Local Properties
    var saleItem: SaleItem?
    
    // MARK: - Public Helpers
    
}
