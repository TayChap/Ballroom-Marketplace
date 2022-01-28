//
//  SaleItemCellStructure.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemCellStructure: Codable {
    var type: SaleItemCellType
    var inputType: InputType
    var serverKey: String // if empty, then front-end only
    var title: String
    var subtitle: String
    var placeholder: String
    var required: Bool
    var filterEnabled: Bool
    var values: [PickerValue]
}