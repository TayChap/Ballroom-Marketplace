//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct Image: Codable {
    let url: String
    var data: Data? = nil
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
