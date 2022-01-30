//
//  Message.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import MessageKit

struct Message: Codable, MessageType {
    let content: String
    
    // MessageType
    let messageId: String
    let sentDate: Date
    let senderId: String // user UID
    let displayName: String
    
    var sender: SenderType {
        Sender(senderId: senderId, displayName: displayName)
    }
    
    var kind: MessageKind {
        .text(content)
    }
}
