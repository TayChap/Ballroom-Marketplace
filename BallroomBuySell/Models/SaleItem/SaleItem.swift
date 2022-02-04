//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Codable {
    enum QueryKeys: String {
        case dateAdded
    }
    
    var dateAdded: Date? = nil
    var userId: String
    var images = [SaleItemImage]()
    var fields: [String: String] = [:] // [serverKey: value]
}
