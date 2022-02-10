//
//  Message.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import MessageKit
import UIKit

struct Message: Codable, MessageType {
    let content: String
    
    // MessageType
    var messageId = UUID().uuidString
    let senderId: String
    let sentDate: Date
    let imageURL: String?
    let displayName: String
    
    var sender: SenderType {
        Sender(senderId: senderId, displayName: displayName, imageURL: imageURL)
    }
    
    var kind: MessageKind {
        .text(content)
    }
}
