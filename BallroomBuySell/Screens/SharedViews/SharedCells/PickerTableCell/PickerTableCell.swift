//
//  PickerTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import UIKit

protocol PickerCellDelegate {
    func pickerValueUpdated(_ newValues: [String], for cell: PickerTableCell)
    func clearButtonClicked(for cell: PickerTableCell)
    func pickerTextUpdated(_ newValue: String, for cell: PickerTableCell)
}

extension PickerCellDelegate {
    func clearButtonClicked(for cell: PickerTableCell){}
    func pickerTextUpdated(_ newValue: String, for cell: PickerTableCell){}
}

class PickerTableCell: UITableViewCell, UITextFieldDelegate, TableCellProtocol, PickerDelegate {
    enum PickerTypes: String {
        case picker, date
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var underline: UIView!
    
    @IBOutlet weak var clearButtonWidth: NSLayoutConstraint!
    
    var delegate: PickerCellDelegate?
    
    static let otherMapping = "otherMapping"
    private let clearButtonWidthSize: CGFloat = 30
    private var pickerType = PickerTypes.picker
    private var pickerValues = [[PickerValue]]()
    private var selectedValues = [String]()
    private var defaultMapping = [String]()
    
    private var minimumDate = Date()
    private var maximumDate = Date()
    
    private(set) var isEnabled = false
    
    static func registerCell(_ tableView: UITableView) {
          let identifier = String(describing: PickerTableCell.self)
          tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView) -> PickerTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PickerTableCell.self)) as? PickerTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: PickerCellDM) {
        clearContent()
        
        isEnabled = dm.isEnabled
        
        pickerType = dm.pickerType
        minimumDate = dm.minimumDate
        maximumDate = dm.maximumDate
        selectedValues = dm.selectedValues
        defaultMapping = dm.defaultMapping
        pickerValues = dm.pickerValues
        
        // Title label
        titleLabel.attributedText = NSAttributedString(string: dm.titleText)
        
        // Detail label
        detailLabel.text = dm.detailText ?? getLocalizedText()
        
        // Other text field
        otherTextField.isHidden = detailLabel.text != "generic.other.colon"
        if selectedValues.first != PickerTableCell.otherMapping {
            otherTextField.text = selectedValues.first
        }
        otherTextField.delegate = self
        
        // Clear button
        clearButton.isHidden = dm.pickerType != .date || !dm.isEnabled || dm.selectedValues.first?.isEmpty == true
        clearButton.setImage(UIImage(named: "clearIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButtonWidth.constant = clearButton.isHidden ? 0 : clearButtonWidthSize
    }
    
    func clearContent() {
        titleLabel.attributedText = nil
        detailLabel.text = nil
        otherTextField.text = nil
        otherTextField.attributedPlaceholder = nil
        otherTextField.isHidden = false
        clearButton.isHidden = true
        clearButtonWidth.constant = clearButtonWidthSize
        
        accessoryType = .none
    }
    
    // MARK: - IBAction
    @IBAction func clearButtonClicked() {
        delegate?.clearButtonClicked(for: self)
    }
    
    // MARK: - Picker Datasource
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: pickerValues[component][row].localizationKey, attributes: [.foregroundColor: UIColor.red])
    }
    
    // MARK: - Picker Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerValues[component].count
    }
    
    func startingSelectedIndexForComponent(component: Int) -> Int {
        guard let keyIndex = pickerValues[component].firstIndex(where: { selectedValues[component] == $0.serverKey }), !selectedValues.allSatisfy({ $0.isEmpty }) || defaultMapping.allSatisfy({ $0.isEmpty }) else {
            if let defaultIndex = pickerValues[component].map({ $0.serverKey }).firstIndex(of: defaultMapping[component]) {
                return defaultIndex
            }
            
            return 0
        }
        
        return keyIndex
    }
    
    func pickerView(picker: UIPickerView, clickDoneForDataSource: PickerDelegate) {
        let numberOfComponents = picker.numberOfComponents
        var values = [String]()
        
        for i in 0..<numberOfComponents {
            values.append(pickerValues[i][picker.selectedRow(inComponent: i)].serverKey)
        }
        
        delegate?.pickerValueUpdated(values, for: self)
    }
    
    // MARK: Date Picker Methods
    func setupDatePicker() -> (startingDate: Date?, maximumDate: Date?, minimumDate: Date?, mode: UIDatePicker.Mode)? {
        let datePickerMode: UIDatePicker.Mode = pickerType == .date ? .date : .dateAndTime
        
        guard let startStringValue = selectedValues.first, !startStringValue.isEmpty else {
            let startValue = Date.toDateFromReadableString(dateString: defaultMapping.first ?? "") ?? Date()
            return (startingDate: startValue, maximumDate: maximumDate, minimumDate: minimumDate, datePickerMode)
        }
        
        let startValue = Date.toDateFromReadableString(dateString: startStringValue)
        return (startingDate: startValue, maximumDate: maximumDate, minimumDate: minimumDate, datePickerMode)
    }
    
    func pickerViewClickDoneFor(datePicker: UIDatePicker) {
        delegate?.pickerValueUpdated([datePicker.date.toReadableString()], for: self)
    }
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            let text = textField.text,
            let textRange = Range(range, in: text)
        else {
            return false
        }
        
        delegate?.pickerTextUpdated(text.replacingCharacters(in: textRange, with: string), for: self)
        return true
    }
    
    // MARK: - Private Helpers
    private func getLocalizedText() -> String {
        guard let first = selectedValues.first else {
            return ""
        }
        
//        switch pickerType {
//        case .picker:
//            if let key = pickerValues.first?.first(where: { first == $0.serverMapping })?.localizationKey {
//                if first.isEmpty {
//                    let localizedText = key.isEmpty ? LocalizationManager.localizedString(forKey: "generic.select.one") : LocalizationManager.localizedString(forKey: key)
//                    return isEnabled ? localizedText : ""
//                }
//
//                return key.isEmpty ? first : LocalizationManager.localizedString(forKey: key)
//            }
//
//            // if disabled or Other is not an option, then do not display Other
//            return isEnabled && pickerValues.first?.first(where: { $0.serverMapping == PickerTableCell.otherMapping }) != nil ? LocalizationManager.localizedString(forKey: "generic.other.colon") : first
//        case .date, .dateTime:
//            return first.isEmpty ? LocalizationManager.localizedString(forKey: "generic.select.one") : first
//        }
        
        return first
    }
}
