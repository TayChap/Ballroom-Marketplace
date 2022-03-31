//
//  PickerValue.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

struct PickerValue: Codable {
    let serverKey: String
    let localizationKey: String
    
    static var emptyEntry: PickerValue {
        PickerValue(serverKey: "", localizationKey: "")
    }
    
    static func getMeasurements(for range: (min: Double, max: Double), with increment: Double) -> [PickerValue] {
        let values = stride(from: range.min, through: range.max, by: increment)
        return values.map({ PickerValue(serverKey: "\($0)", localizationKey: "\($0) \"") })
    }
}
