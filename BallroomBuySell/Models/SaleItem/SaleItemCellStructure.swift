//
//  SaleItemCellStructure.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemCellStructure: Codable {
    var type: SaleItemCellType // UI element type
    var serverKey: String // if empty, then front-end only
    var title: String
    var subtitle: String
    var placeholder: String
    var required: Bool
    var values: [PickerValue]
}
