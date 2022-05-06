//
//  User.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct User: Codable {
    let id: String
    let photoURL: String?
    let displayName: String
    var blockedSaleItemIds = [String]()
    var blockedUserIds = [String]()
}
