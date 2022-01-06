//
//  PickerCellDM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import Foundation

struct PickerCellDM {
    /// The text displayed for the title field
    let titleText: String
    /// The currently selected values corresponding to the serverKey values passed in via pickerValues
    var selectedValues: [String]
    /// The user facing string displayed to the user (only passed in if differs from selectedValues)
    var detailText: String? = nil
    /// The default serverMapping to set the picker to in pickerValues
    var defaultMapping: [String] = [""]
    /// Ordered options for the picker
    var pickerValues: [[PickerValue]]
    /// isEnabled is false only if read only
    var isEnabled = true
    /// The type of the picker (for instance, picker, date, time, etc.)
    var pickerType = PickerTableCell.PickerTypes.picker
    /// If we should show the required asterisk
    var showRequiredAsterisk: Bool
    /// For .date pickers, set the minimum date
    var minimumDate = Date.distantPast
    /// For .date  pickers, set the maximum date
    var maximumDate = Date()
}
