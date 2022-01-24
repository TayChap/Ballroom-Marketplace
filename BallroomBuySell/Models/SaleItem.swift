//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Codable {
    var dateAdded: Date? = nil
    // TODO! USER ID ?
    var images = [Image]()
    var fields: [String: String] = [:] // [serverKey: value] connected to UI elements in SaleItemTemplate
}
