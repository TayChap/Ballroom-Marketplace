//
//  SaleItemVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import UIKit

struct SaleItemVM {
    enum Mode {
        case create, edit, view, filter
        
        var showRequiredAsterisk: Bool {
            switch self {
            case .edit, .create: return true
            case .view, .filter: return false
            }
        }
        
        var isEditable: Bool {
            self != .view
        }
    }
    
    // MARK: - Stored Properties
    private var saleItem: SaleItem
    private weak var delegate: ViewControllerProtocol?
    
    private let mode: Mode
    private var screenStructure = [SaleItemCellStructure]()
    private let templates: [SaleItemTemplate]
    private let hideContactSeller: Bool
    private let updateFilter: ((SaleItem) -> Void)?
    
    // MARK: Computed Properties
    private var selectedTemplate: SaleItemTemplate? {
        templates.first(where: { $0.id == saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] })
    }
    
    private var requiredFieldsFilled: Bool {
        if saleItem.images.isEmpty {
            return false
        }
        
        let requiredFields = screenStructure.filter({ $0.required && !$0.serverKey.isEmpty && $0.serverKey != SaleItem.QueryKeys.images.rawValue }).map({ $0.serverKey })
        return requiredFields.allSatisfy { requiredField in
            guard let value = saleItem.fields[requiredField] else {
                return false
            }
            
            return !value.isEmpty
        }
    }
    
    // MARK: - Navigation Bar
    var title: String {
        switch mode {
        case .view:
            return ""
        case .create:
            return LocalizedString.string("generic.new.listing")
        case .edit:
            return LocalizedString.string("generic.edit.listing")
        case .filter:
            guard let selectedTemplate = selectedTemplate else {
                return ""
            }
            
            return "\(LocalizedString.string("generic.sort")): \(LocalizedString.string(selectedTemplate.name))"
        }
    }
    
    var backButtonImage: UIImage? {
        UIImage(systemName: mode == .filter ? "xmark" : "chevron.left")
    }
    
    var doneButtonImage: UIImage? {
        switch mode {
        case .edit, .create, .filter:
            return UIImage(systemName: "checkmark")
        case .view:
            return nil
        }
    }
    
    var reportButtonImage: UIImage? {
        mode == .view && !hideContactSeller ? UIImage(systemName: "flag")?.withTintColor(Theme.Color.error.value) : nil
    }
    
    var messageButtonImage: UIImage? {
        mode == .view && !hideContactSeller ? UIImage(systemName: "envelope") : nil
    }
    
    // MARK: - Lifecycle Methods
    init(owner: ViewControllerProtocol,
         mode: Mode,
         templates: [SaleItemTemplate],
         selectedTemplate: SaleItemTemplate? = nil,
         saleItem: SaleItem? = nil,
         hideContactSeller: Bool,
         updateFilter: ((SaleItem) -> Void)?) {
        delegate = owner
        self.mode = mode
        self.templates = templates
        self.saleItem = saleItem ?? SaleItem(userId: AuthenticationManager.sharedInstance.user?.id ?? "")
        self.hideContactSeller = AuthenticationManager.sharedInstance.user?.id == self.saleItem.userId || hideContactSeller
        self.updateFilter = updateFilter
        
        // update pre selected template for filter mode
        guard let selectedTemplateId = selectedTemplate?.id else {
            return
        }
        
        self.saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] = selectedTemplateId
    }
    
    mutating func viewDidLoad(with tableView: UITableView) {
        screenStructure = getScreenStructure()
        
        PickerTableCell.registerCell(for: tableView)
        TextFieldTableCell.registerCell(for: tableView)
        ImageTableCell.registerCell(for: tableView)
        SwitchTableCell.registerCell(for: tableView)
        TextViewTableCell.registerCell(for: tableView)
        ButtonTableCell.registerCell(for: tableView)
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        switch mode {
        case .create:
            let cancel = UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel)
            let discard = UIAlertAction(title: LocalizedString.string("generic.discard"), style: .destructive) { _ in
                delegate?.dismiss()
            }
            
            delegate?.showAlertWith(message: LocalizedString.string("alert.unsaved.message"), alertActions: [cancel, discard])
        case .view, .filter, .edit:
            delegate?.dismiss()
        }
    }
    
    func doneButtonClicked() {
        switch mode {
        case .create, .edit:
            guard requiredFieldsFilled else {
                delegate?.showAlertWith(message: LocalizedString.string("alert.required.fields.message"))
                return
            }
            
            do {
                try DatabaseManager.sharedInstance.putDocument(in: .items,
                                                               for: saleItem)
                Image.uploadImages(saleItem.images)
                
                let ok = UIAlertAction(title: LocalizedString.string("generic.ok"), style: .default) { _ in
                    delegate?.dismiss()
                }
                
                delegate?.showAlertWith(message: LocalizedString.string("generic.success"), alertActions: [ok])
            } catch {
                delegate?.showNetworkError(error)
            }
        case .filter:
            updateFilter?(saleItem)
            delegate?.dismiss()
        case .view:
            break
        }
    }
    
    func messageButtonClicked() {
        if AuthenticationManager.sharedInstance.user == nil {
            delegate?.present(AppleLoginVC.createViewController(pushMessageThread), animated: false)
            return
        }
        
        Task {
            await pushMessageThread()
        }
    }
    
    func reportButtonClicked() {
        if AuthenticationManager.sharedInstance.user == nil {
            delegate?.present(AppleLoginVC.createViewController(submitReport), animated: false)
            return
        }
        
        submitReport()
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellStructure = screenStructure[indexPath.row]
        switch cellStructure.type {
        case .picker:
            guard let cell = PickerTableCell.createCell(for: tableView) else {
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
                
                pickerValues = PickerValue.getMeasurements(for: (min: cellStructure.min,
                                                                 max: max),
                                                           with: cellStructure.increment)
            default:
                pickerValues = cellStructure.values
            }
            
            cell.configureCell(with: PickerCellDM(titleText: LocalizedString.string(cellStructure.title),
                                                  selectedValues: [saleItem.fields[cellStructure.serverKey] ?? ""],
                                                  pickerValues: [pickerValues],
                                                  showRequiredAsterisk: cellStructure.required && mode.showRequiredAsterisk))
            cell.delegate = owner as? PickerCellDelegate
            return cell
        case .textField:
            guard let cell = TextFieldTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: TextFieldCellDM(inputType: cellStructure.inputType,
                                                     title: LocalizedString.string(cellStructure.title),
                                                     detail: saleItem.fields[cellStructure.serverKey] ?? "",
                                                     returnKeyType: .done,
                                                     showRequiredAsterisk: cellStructure.required && mode.showRequiredAsterisk,
                                                     isEnabled: mode.isEditable))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        case .imageCollection:
            guard let cell = ImageTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: ImageCellDM(title: LocalizedString.string(cellStructure.title),
                                                 images: saleItem.images.compactMap({ $0.data }),
                                                 showRequiredAsterisk: cellStructure.required && mode.showRequiredAsterisk,
                                                 editable: mode.isEditable))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .toggle:
            guard let cell = SwitchTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: SwitchCellDM(title: LocalizedString.string(cellStructure.title),
                                                  isSelected: saleItem.useStandardSizing,
                                                  isEnabled: mode.isEditable))
            cell.delegate = owner as? SwitchCellDelegate
            return cell
        case .textView:
            guard let cell = TextViewTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: TextViewCellDM(title: cellStructure.title,
                                                    detail: saleItem.fields[cellStructure.serverKey] ?? "",
                                                    isEnabled: mode.isEditable))
            cell.delegate = owner as? TextViewCellDelegate
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        if mode == .view {
            return
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? PickerTableCell {
            let pickerVC = PickerViewController.createViewController(delegate: selectedCell,
                                                                     owner: delegate)
            pickerVC.presentLayerIn(viewController: viewController, withDataSource: selectedCell)
        }
    }
    
    // MARK: - ImageCellDelegate
    mutating func newImage(_ data: Data) {
        saleItem.images.append(Image(for: .saleItems, data: data))
    }
    
    mutating func deleteImage(at index: Int) {
        saleItem.images.remove(at: index)
    }
    
    // MARK: - SwitchCellDelegate
    mutating func updateSwitchDetail(_ isOn: Bool,
                                     for cell: SwitchTableCell) {
        saleItem.useStandardSizing = isOn
        screenStructure = getScreenStructure()
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String,
                          at indexPath: IndexPath) {
        let cellStructure = screenStructure[indexPath.row]
        saleItem.fields[cellStructure.serverKey] = data
        
        if cellStructure.serverKey == SaleItemTemplate.serverKey.templateId.rawValue {
            screenStructure = getScreenStructure()
        }
    }
    
    // MARK: - Private Helpers
    /// Get filtered screen structure for current screen mode and data state
    /// - Returns: screenStructure for current screen mode and data state
    private func getScreenStructure() -> [SaleItemCellStructure] {
        var structure = SaleItemTemplate.getScreenStructure(with: templates, for: selectedTemplate)
        
        // determine size metrics used
        structure = structure.filter({ saleItem.useStandardSizing ? $0.inputType != .measurement :  $0.inputType != .standardSize })
        
        switch mode {
        case .create, .edit:
            break
        case .view:
            // exclude blank fields for view mode
            structure = structure.filter({ !(saleItem.fields[$0.serverKey] ?? "").isEmpty || $0.serverKey == SaleItem.QueryKeys.images.rawValue })
        case .filter:
            structure = structure.filter({ $0.filterEnabled })
        }
        
        return structure
    }
    
    @MainActor
    private func pushMessageThread() async {
        guard let user = AuthenticationManager.sharedInstance.user else {
            return
        }
        
        do {
            let threads = try await DatabaseManager.sharedInstance.getDocuments(to: .threads,
                                                                                of: MessageThread.self,
                                                                                whereFieldEquals: (key: MessageThread.QueryKeys.buyerId.rawValue, value: user.id))
            
            let messageThread = threads.first(where: { $0.saleItemId == saleItem.id }) ??
            MessageThread(buyerId: user.id,
                          sellerId: saleItem.userId,
                          saleItemId: saleItem.id,
                          saleItemType: saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] ?? "",
                          imageURL: saleItem.images.first?.url ?? "")
            
            let otherUser = try await DatabaseManager.sharedInstance.getDocument(in: .users,
                                                                                 of: User.self,
                                                                                 with: messageThread.otherUserId)
            
            delegate?.pushViewController(MessageThreadVC.createViewController(messageThread,
                                                                              currentUser: user,
                                                                              otherUser: otherUser,
                                                                              templates: templates,
                                                                              hideItemInfo: true))
        } catch {
            delegate?.showNetworkError()
        }
    }
    
    private func submitReport() {
        guard let user = AuthenticationManager.sharedInstance.user else {
            return
        }
        
        Report.submitReport(for: saleItem,
                            with: LocalizedString.string("flag.reason"),
                            delegate: delegate,
                            reportingUser: user)
    }
}
