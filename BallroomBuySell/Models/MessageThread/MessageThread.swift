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
    let title: String // TODO! rename to saleItemType
    let imageURL: String
    var messages: [Message] = []
}
