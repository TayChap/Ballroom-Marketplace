//
//  MessageThread.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct MessageThread: Storable, Reportable {
    enum QueryKeys: String {
        case userIds, saleItemId
    }
    
    var userId: String { // the id of the other user in the conversation
        userIds.filter({ AuthenticationManager.sharedInstance.user?.id != $0 }).first ?? ""
    }
    
    var id = UUID().uuidString
    var userIds: Set<String>
    let saleItemId: String
    let saleItemType: String
    let imageURL: String
    var messages: [Message] = []
}
