//
//  SaleItemVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import UIKit

struct SaleItemVM {
    enum Mode {
        case create, view
    }
    
    private var dm = SaleItem()
    weak var delegate: ViewControllerProtocol?
    let mode: Mode
    var screenStructure: [SaleItemCellStructure]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ saleItem: SaleItem? = nil) {
        delegate = owner
        mode = saleItem == nil ? .create : .view
        screenStructure = SaleItemVM.getScreenStructure(for: saleItem?.fields[SaleItemTemplate.serverKey])
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        PickerTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    mutating func doneButtonClicked() {
        dm.dateAdded = Date()
        DatabaseManager().createDocument(.items, dm)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellStructure = screenStructure[indexPath.row]
        
        switch cellStructure.type {
        case .picker:
            guard let cell = PickerTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(PickerCellDM(titleText: cellStructure.title,
                                            selectedValues: [dm.fields[cellStructure.serverKey] ?? ""],
                                            pickerValues: [cellStructure.values],
                                            showRequiredAsterisk: cellStructure.required))
            cell.delegate = owner as? PickerCellDelegate
            return cell
        case .textField:
            guard let cell = TextFieldTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(TextFieldCellDM(inputType: cellStructure.inputType,
                                               title: cellStructure.title,
                                               detail: dm.fields[cellStructure.serverKey] ?? "",
                                               returnKeyType: .done))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? PickerTableCell {
            let pickerVC = PickerViewController.createViewController(selectedCell)
            pickerVC.presentLayerIn(viewController: viewController, withDataSource: selectedCell)
        }
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        let cellStructure = screenStructure[indexPath.row]
        dm.fields[cellStructure.serverKey] = data
        
        if cellStructure.serverKey == SaleItemTemplate.serverKey {
            screenStructure = SaleItemVM.getScreenStructure(for: data)
        }
    }
    
    // MARK: - Private Helpers
    private static func getScreenStructure(for templateId: String?) -> [SaleItemCellStructure] {
        [SaleItemTemplate.getTemplateSelectorItem(TemplateManager.templates)] +
            (TemplateManager.templates.first(where: { $0.id == templateId })?.screenStructure ?? [])
    }
}
