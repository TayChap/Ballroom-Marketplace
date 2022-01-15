//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Codable {
    var dateAdded: Date? = nil
    // USER ID ?
    var imageURLs = [String]()
    var fields: [String: String] = [:] // [serverKey: value] connected to UI elements in SaleItemTemplate
}
