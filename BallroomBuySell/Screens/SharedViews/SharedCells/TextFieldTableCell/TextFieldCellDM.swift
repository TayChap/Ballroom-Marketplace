//
//  TextFieldCellDM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct TextFieldCellDM {
    let type: TextFieldTableCell.InputType
    let title: String
    var subtitle: String = ""
    let detail: String
    let returnKeyType: UIReturnKeyType
}