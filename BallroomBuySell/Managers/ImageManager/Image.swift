//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct Image: Codable {
    let url: String // TODO! consider changing to URL type like in photoURL property of user
    var data: Data? = nil
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
