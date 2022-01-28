//
//  Message.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import Foundation

struct Message: Codable {
    var created: Date
    var user: String
    var content: String
}
