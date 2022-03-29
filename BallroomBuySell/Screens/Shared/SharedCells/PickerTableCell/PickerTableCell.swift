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
}

extension PickerCellDelegate {
    func clearButtonClicked(for cell: PickerTableCell){}
}

class PickerTableCell: UITableViewCell, UITextFieldDelegate, TableCellProtocol, PickerDelegate {
    enum PickerTypes: String {
        case picker, date
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var underline: UIView!
    
    @IBOutlet weak var clearButtonWidth: NSLayoutConstraint!
    
    var delegate: PickerCellDelegate?
    
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
        detailLabel.text = LocalizedString.string(dm.pickerValues[0].first(where: { $0.serverKey == selectedValues[0] })?.localizationKey ?? "")
        
        // Clear button
        clearButton.isHidden = dm.pickerType != .date || !dm.isEnabled || dm.selectedValues.first?.isEmpty == true
        clearButton.setImage(UIImage(named: "clearIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButtonWidth.constant = clearButton.isHidden ? 0 : clearButtonWidthSize
    }
    
    func clearContent() {
        titleLabel.attributedText = nil
        detailLabel.text = nil
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
        NSAttributedString(string: LocalizedString.string(pickerValues[component][row].localizationKey), attributes: [.foregroundColor: UIColor.red])
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
}
