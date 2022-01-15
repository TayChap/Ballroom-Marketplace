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
    
    private var dm: SaleItem
    weak var delegate: ViewControllerProtocol?
    let mode: Mode
    var screenStructure: [SaleItemCellStructure]
    
    var images = [Data]() // TODO! store in DM
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ saleItem: SaleItem? = nil) {
        delegate = owner
        screenStructure = SaleItemVM.getScreenStructure(for: saleItem?.fields[SaleItemTemplate.serverKey])
        
        if let saleItem = saleItem {
            mode = .view
            dm = saleItem
            return
        }
        
        mode = .create
        dm = SaleItem()
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        PickerTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
        ImageTableCell.registerCell(tableView)
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
        case .imageCollection:
            guard let cell = ImageTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(ImageCellDM(title: cellStructure.title,
                                           images: images,
                                           editable: mode == .create))
            cell.delegate = owner as? (ImageTableCellDelegate & UIViewController)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? PickerTableCell {
            let pickerVC = PickerViewController.createViewController(selectedCell)
            pickerVC.presentLayerIn(viewController: viewController, withDataSource: selectedCell)
        }
    }
    
    // MARK: - ImageCellDelegate
    mutating func newImage(_ data: Data) {
        images.append(data)
    }
    
    mutating func deleteImage(at index: Int) {
        images.remove(at: index)
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
        SaleItemTemplate.getSaleItemHeader(TemplateManager.templates) +
            (TemplateManager.templates.first(where: { $0.id == templateId })?.screenStructure ?? [])
    }
}
