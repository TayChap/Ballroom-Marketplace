//
//  Message.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import MessageKit
import UIKit

struct Message: Codable, MessageType {
    enum CodingKeys: String, CodingKey {
        case messageId, content, senderId, sentDate
    }
    
    var messageId = UUID().uuidString
    let content: String
    let senderId: String
    let sentDate: Date
    
    // MARK: Local Only Fields
    var imageURL: String?
    var displayName = ""
    
    // MARK: - Computed Properties
    var sender: SenderType {
        Sender(senderId: senderId,
               displayName: displayName,
               imageURL: imageURL)
    }
    
    var kind: MessageKind {
        .text(content)
    }
}
