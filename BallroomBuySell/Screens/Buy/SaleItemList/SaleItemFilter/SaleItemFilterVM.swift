//
//  SaleItemFilterVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

struct SaleItemFilterVM {
    
    // MARK: - IBActions
    func backButtonClcked() {
        
    }
    
    func submitButtonClicked() {
        
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 // TODO! screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        
        UITableViewCell()
        
//        let cellStructure = screenStructure[indexPath.row]
//        switch cellStructure.type {
//        case .picker:
//            guard let cell = PickerTableCell.createCell(tableView) else {
//                return UITableViewCell()
//            }
//
//            cell.configureCell(PickerCellDM(titleText: cellStructure.title,
//                                            selectedValues: [dm.fields[cellStructure.serverKey] ?? ""],
//                                            pickerValues: [cellStructure.values],
//                                            showRequiredAsterisk: cellStructure.required))
//            cell.delegate = owner as? PickerCellDelegate
//            return cell
//        case .textField:
//            guard let cell = TextFieldTableCell.createCell(tableView) else {
//                return UITableViewCell()
//            }
//
//            cell.configureCell(TextFieldCellDM(inputType: cellStructure.inputType,
//                                               title: cellStructure.title,
//                                               detail: dm.fields[cellStructure.serverKey] ?? "",
//                                               returnKeyType: .done))
//            cell.delegate = owner as? TextFieldCellDelegate
//            return cell
//        }
//
        
    }
}
