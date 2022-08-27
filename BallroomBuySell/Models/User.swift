//
//  User.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct User: Storable {
    enum QueryKeys: String {
        case id
    }
    
    let id: String
    var email: String?
    var photoURL: String?
    var displayName: String
    var blockedUserIds = [String]()
}
