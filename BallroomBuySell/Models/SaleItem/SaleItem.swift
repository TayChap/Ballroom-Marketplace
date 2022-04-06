//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Codable {
    enum QueryKeys: String {
        case id, dateAdded, userId, images
    }
    
    var filterFields: [String: String] {
        // TODO!
        return [:]
    }
    
    var id = UUID().uuidString
    var dateAdded = Date()
    var userId: String
    var images = [Image]()
    var useStandardSizing = false
    var fields: [String: String] = [:] // [serverKey: value]
}
