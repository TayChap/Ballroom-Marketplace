//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Codable {
    enum QueryKeys: String {
        case userIds
    }
    
    var id = UUID().uuidString
    var userIds: Set<String>
    let saleItemId: String
    let imageURL: String
    let title: String
    var messages: [Message] = []
}
