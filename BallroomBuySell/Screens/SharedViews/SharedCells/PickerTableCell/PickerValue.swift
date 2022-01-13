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
}
