//
//  SaleItemVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import UIKit

struct SaleItemVM {
    enum Mode {
        case create, view, filter
    }
    
    private var saleItem: SaleItem
    private weak var delegate: ViewControllerProtocol?
    
    private let mode: Mode
    private var screenStructure = [SaleItemCellStructure]()
    private let templates: [SaleItemTemplate]
    private let hideContactSeller: Bool
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, mode: Mode, templates: [SaleItemTemplate], saleItem: SaleItem? = nil, hideContactSeller: Bool = false) {
        delegate = owner
        self.mode = mode
        self.templates = templates
        self.saleItem = saleItem ?? SaleItem(userId: AuthenticationManager().user?.id ?? "")
        self.hideContactSeller = AuthenticationManager().user?.id == self.saleItem.userId || hideContactSeller // TODO! re-evaluate
    }
    
    mutating func viewDidLoad(_ tableView: UITableView) {
        screenStructure = getScreenStructure()
        
        PickerTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
        ImageTableCell.registerCell(tableView)
        SwitchTableCell.registerCell(tableView)
        TextViewTableCell.registerCell(tableView)
        ButtonTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    mutating func doneButtonClicked(_ updateFilter: ((SaleItem) -> Void)? = nil) {
        saleItem.dateAdded = Date()
        switch mode {
        case .create:
            DatabaseManager.sharedInstance.createDocument(.items, saleItem)
            Image.uploadImages(saleItem.images)
        case .filter:
            updateFilter?(saleItem)
        case .view:
            break
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
            
            var pickerValues: [PickerValue]
            switch cellStructure.inputType {
            case .country:
                pickerValues = Country.getCountryPickerValues.map({ PickerValue(serverKey: $0.code, localizationKey: $0.localizedString) })
            case .measurement:
                guard let max = cellStructure.max else {
                    return UITableViewCell()
                }
                
                pickerValues = PickerValue.getPickerValues(for: (min: cellStructure.min, max: max), with: cellStructure.increment)
            default:
                pickerValues = cellStructure.values
            }
            
            cell.configureCell(PickerCellDM(titleText: LocalizedString.string(cellStructure.title),
                                            selectedValues: [saleItem.fields[cellStructure.serverKey] ?? ""],
                                            pickerValues: [pickerValues],
                                            showRequiredAsterisk: cellStructure.required))
            cell.delegate = owner as? PickerCellDelegate
            return cell
        case .textField:
            guard let cell = TextFieldTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(TextFieldCellDM(inputType: cellStructure.inputType,
                                               title: LocalizedString.string(cellStructure.title),
                                               detail: saleItem.fields[cellStructure.serverKey] ?? "",
                                               returnKeyType: .done,
                                               isEnabled: mode != .view))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        case .imageCollection:
            guard let cell = ImageTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(ImageCellDM(title: LocalizedString.string(cellStructure.title),
                                           images: saleItem.images.compactMap({ $0.data }),
                                           editable: mode == .create))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .toggle:
            guard let cell = SwitchTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(SwitchCellDM(title: LocalizedString.string(cellStructure.title),
                                            isSelected: saleItem.useStandardSizing,
                                            isEnabled: mode != .view))
            cell.delegate = owner as? SwitchCellDelegate
            return cell
        case .textView:
            guard let cell = TextViewTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(TextViewCellDM(title: cellStructure.title,
                                               detail: saleItem.fields[cellStructure.serverKey] ?? "",
                                               isEnabled: mode != .view))
            cell.delegate = owner as? TextViewCellDelegate
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
        saleItem.images.append(Image(data: data))
    }
    
    mutating func deleteImage(at index: Int) {
        saleItem.images.remove(at: index)
    }
    
    // MARK: - SwitchCellDelegate
    mutating func updateSwitchDetail(_ newValue: Bool, for cell: SwitchTableCell) {
        saleItem.useStandardSizing = newValue
        screenStructure = getScreenStructure()
    }
    
    // MARK: - ButtonCellDelegate
    func buttonClicked(_ signIn: () -> Void) {
        guard let user = AuthenticationManager().user else {
            signIn()
            return
        }
        
        DatabaseManager.sharedInstance.getThreads(for: user.id) { threads in
            let messageThread = threads.first(where: { $0.saleItemId == saleItem.id }) ??
            MessageThread(userIds: [user.id, saleItem.userId],
                          saleItemId: saleItem.id,
                          imageURL: saleItem.images.first?.url ?? "",
                          title: saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] ?? "")
            
            delegate?.pushViewController(MessageThreadVC.createViewController(messageThread,
                                                                              user: user,
                                                                              templates: templates,
                                                                              hideItemInfo: true))
        }
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        let cellStructure = screenStructure[indexPath.row]
        saleItem.fields[cellStructure.serverKey] = data
        
        if cellStructure.serverKey == SaleItemTemplate.serverKey.templateId.rawValue {
            screenStructure = getScreenStructure()
        }
    }
    
    // MARK: - Private Helpers
    private func getScreenStructure() -> [SaleItemCellStructure] {
        var structure = SaleItemTemplate.getHeaderCells(templates) +
            (templates.first(where: { $0.id == saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] })?.screenStructure ?? []).filter({ mode != .view || !(saleItem.fields[$0.serverKey] ?? "").isEmpty }) + // exclude blank fields for view mode
            SaleItemTemplate.getFooterCells()
        
        // determine size metrics used
        structure = structure.filter({ saleItem.useStandardSizing ? $0.inputType != .measurement :  $0.inputType != .standardSize })
        
        if mode == .filter {
            structure = structure.filter({ $0.filterEnabled })
        }
        
        if !hideContactSeller {
            structure.append(SaleItemTemplate.getContactSellerCell())
        }
        
        return structure
    }
}
