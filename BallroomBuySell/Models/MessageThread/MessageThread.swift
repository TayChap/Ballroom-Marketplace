//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Codable {
    var id = UUID().uuidString
    let userIds: [String]
    let saleItemId: String
    var messages: [Message] = []
    
    // TODO! message thread should contain LOCAL ONLY sale item info fetched from id (?)
}
