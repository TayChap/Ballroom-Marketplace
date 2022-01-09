//
//  SellVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import UIKit

struct SellVM {
    weak var delegate: ViewControllerProtocol?
    let templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ templates: [SaleItemTemplate]) {
        delegate = owner
        self.templates = templates
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        PickerTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    func doneButtonClicked() {
//        DatabaseManager().createItem()
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        guard let cell = PickerTableCell.createCell(tableView) else {
            return UITableViewCell()
        }
        
        let pickerValues = [[PickerValue(serverKey: "", localizationKey: "")]]
        let selectedValue = ""
        cell.configureCell(PickerCellDM(titleText: "title",
                                        selectedValues: [selectedValue],
                                        pickerValues: pickerValues,
                                        showRequiredAsterisk: false))
        cell.delegate = owner as? PickerCellDelegate
        return cell
    }
    
    mutating func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? PickerTableCell {
            let pickerVC = PickerViewController.createViewController(selectedCell)
            pickerVC.presentLayerIn(viewController: viewController, withDataSource: selectedCell)
        }
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        //dm[LoginItem.allCases[indexPath.row]] = data TODO!
    }
}
