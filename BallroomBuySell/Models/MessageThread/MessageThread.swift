//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Codable {
    enum QueryKeys: String {
        case userIds, saleItemId
    }
    
    var id = UUID().uuidString
    var userIds: Set<String>
    let saleItemId: String
    let saleItemType: String
    let imageURL: String
    var messages: [Message] = []
}
