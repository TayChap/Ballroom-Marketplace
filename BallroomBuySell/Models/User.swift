//
//  User.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct User: Storable {
    let id: String
    let email: String?
    var photoURL: String?
    let displayName: String
    var blockedUserIds = [String]()
}
