//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

protocol SaleItem: Codable {
    var size: String { get set }
    var dateAdded: Date { get set }
}
