//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Codable {
    let userIds: [String]
    let saleItemId: String
    var messages: [Message]
}
