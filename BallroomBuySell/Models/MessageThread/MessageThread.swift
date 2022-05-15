//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Storable, Reportable {
    enum QueryKeys: String {
        case buyerId, sellerId, saleItemId
    }
    
    var id = UUID().uuidString
    let buyerId: String
    let sellerId: String
    let saleItemId: String
    let saleItemType: String // TODO! can change - investigate when review inbox UI/UX
    let imageURL: String
    var messages: [Message] = []
    
    // MARK: - Computed Properties
    var otherUserId: String {
        AuthenticationManager.sharedInstance.user?.id == buyerId ? sellerId : buyerId
    }
    
    var reportableUserId: String { // the id of the other user in the conversation
        otherUserId
    }
}
