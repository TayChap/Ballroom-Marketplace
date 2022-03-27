//
//  SaleItemCellStructure.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemCellStructure: Codable {
    let type: SaleItemCellType
    let inputType: InputType
    let serverKey: String // if empty, then front-end only
    let title: String
    let subtitle: String
    let placeholder: String
    let required: Bool
    let filterEnabled: Bool
    var values = [PickerValue]() // values for picker
    var min = 0.0 // the minimum value for a picker
    var max: Double? // the maximum value for a picker
    var increment = 1.0 // the amount to increment between the minimum and maximum
}
