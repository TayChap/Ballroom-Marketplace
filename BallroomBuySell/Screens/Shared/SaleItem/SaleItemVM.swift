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
    
    private var saleItem: SaleItem
    private weak var delegate: ViewControllerProtocol?
    
    private let mode: Mode
    private var screenStructure: [SaleItemCellStructure]
    private let templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ templates: [SaleItemTemplate], _ saleItem: SaleItem? = nil) {
        delegate = owner
        self.templates = templates
        
        if let saleItem = saleItem {
            mode = .view
            self.saleItem = saleItem
        } else {
            mode = .create
            self.saleItem = SaleItem(userId: AuthenticationManager().user?.id ?? "")
        }
        
        screenStructure = SaleItemVM.getScreenStructure(templates, AuthenticationManager().user?.id, self.saleItem.userId, for: saleItem?.fields[SaleItemTemplate.serverKey])
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        PickerTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
        ImageTableCell.registerCell(tableView)
        ButtonTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    mutating func doneButtonClicked() {
        saleItem.dateAdded = Date()
        ImageManager.sharedInstance.uploadImagesAsynchronously(saleItem.images)
        DatabaseManager.sharedInstance.createDocument(.items, saleItem)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellStructure = screenStructure[indexPath.row]
        switch cellStructure.type {
        case .picker, .numberPicker:
            guard let cell = PickerTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(PickerCellDM(titleText: cellStructure.title,
                                            selectedValues: [saleItem.fields[cellStructure.serverKey] ?? ""],
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
                                               detail: saleItem.fields[cellStructure.serverKey] ?? "",
                                               returnKeyType: .done))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        case .imageCollection:
            guard let cell = ImageTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(ImageCellDM(title: cellStructure.title,
                                           images: saleItem.images.compactMap({ $0.data }),
                                           editable: mode == .create))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .button:
            guard let cell = ButtonTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(cellStructure.title)
            cell.delegate = owner as? ButtonCellDelegate
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
        saleItem.images.append(Image(url: "images/\(UUID().uuidString)", data: data))
    }
    
    mutating func deleteImage(at index: Int) {
        saleItem.images.remove(at: index)
    }
    
    // MARK: - ButtonCellDelegate
    func buttonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(MessageThreadVC.createViewController(MessageThread(userIds: [user.id, saleItem.userId],
                                                                                        saleItemId: saleItem.userId),
                                                                          user,
                                                                          templates))
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        let cellStructure = screenStructure[indexPath.row]
        saleItem.fields[cellStructure.serverKey] = data
        
        if cellStructure.serverKey == SaleItemTemplate.serverKey {
            screenStructure = SaleItemVM.getScreenStructure(templates, AuthenticationManager().user?.id, saleItem.userId, for: data)
        }
    }
    
    // MARK: - Private Helpers
    private static func getScreenStructure(_ templates: [SaleItemTemplate], _ userId: String?, _ saleItemUserId: String, for templateId: String?) -> [SaleItemCellStructure] {
        // TODO! reduce method argument complexity
        let structure = [SaleItemTemplate.getTemplateSelectorCell(templates)] +
            [SaleItemTemplate.getImageCollectionCelll()] +
            (templates.first(where: { $0.id == templateId })?.screenStructure ?? [])
        
        if userId == saleItemUserId {
            return structure
        }
        
        return structure + [SaleItemTemplate.getContactSellerCell()]
    }
}
