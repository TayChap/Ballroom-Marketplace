//
//  SaleItemFilterVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

struct SaleItemFilterVM {
    private var dm: SaleItemFilter
    private weak var delegate: ViewControllerProtocol?
    private var screenStructure: [SaleItemCellStructure]
    private let templates: [SaleItemTemplate]
    
    private let onFilterFetched: (_ saleItems: [SaleItem]) -> Void
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ templates: [SaleItemTemplate], _ onFilterFetched: @escaping (_ saleItems: [SaleItem]) -> Void) {
        delegate = owner
        self.templates = templates
        self.onFilterFetched = onFilterFetched
        screenStructure = SaleItemFilterVM.getScreenStructure(templates)
        dm = SaleItemFilter()
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        PickerTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
        ImageTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    func backButtonClcked() {
        delegate?.dismiss()
    }
    
    func submitButtonClicked() {
        var templateFilter: (key: String, value: String)? = nil // TODO! refactor all this foolishness...
        if let value = dm.fields[SaleItemTemplate.serverKey]?.first {
            templateFilter = (key: "fields.\(SaleItemTemplate.serverKey)", value: value)
        }
        
        DatabaseManager.sharedInstance.getSaleItems(where: templateFilter) { saleItems in
            onFilterFetched(saleItems)
            delegate?.dismiss()
        }
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
                                            selectedValues: [dm.fields[cellStructure.serverKey]?.first ?? ""],
                                            pickerValues: [cellStructure.values],
                                            showRequiredAsterisk: cellStructure.required))
            cell.delegate = owner as? PickerCellDelegate
            return cell
        case .numberPicker:
            return UITableViewCell() // TODO! potentially setup 2D picker for value ranges!
        case .textField:
            guard let cell = TextFieldTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(TextFieldCellDM(inputType: cellStructure.inputType,
                                               title: cellStructure.title,
                                               detail: dm.fields[cellStructure.serverKey]?.first ?? "",
                                               returnKeyType: .done))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        default: // some cell structure items do not appear on filter page
            return UITableViewCell()
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
        if cellStructure.serverKey == SaleItemTemplate.serverKey {
            dm = SaleItemFilter()
            screenStructure = SaleItemFilterVM.getScreenStructure(templates, for: data)
        }
        
        dm.fields[cellStructure.serverKey] = [data]
    }
    
    // MARK: - Private Helpers
    private static func getScreenStructure(_ templates: [SaleItemTemplate],for templateId: String? = nil) -> [SaleItemCellStructure] {
        [SaleItemTemplate.getTemplateSelectorCell(templates)] +
            (templates.first(where: { $0.id == templateId })?.screenStructure.filter({ $0.filterEnabled }) ?? [])
    }
}
