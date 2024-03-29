//
//  TextFieldTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject { // AnyObject because it must be a class for weak delegate reference
    func textFieldUpdated(with text: String, for cell: TextFieldTableCell)
}

class TextFieldTableCell: UITableViewCell, TableCellProtocol, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    weak var delegate: TextFieldCellDelegate? // weak to prevent strong reference cycle
    
    // MARK: - Lifecycle Methods
    static func registerCell(for tableView: UITableView) {
        let identifier = String(describing: TextFieldTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(for tableView: UITableView) -> TextFieldTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldTableCell.self)) as? TextFieldTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: TextFieldCellDM) {
        clearContent()
        
        titleLabel.attributedText = dm.title.attributedText(color: Theme.Color.primaryText.value, required: dm.showRequiredAsterisk)
        
        subtitleLabel.text = dm.subtitle
        subtitleLabel.isHidden = dm.subtitle.isEmpty
        
        textField.text = dm.detail
        textField.keyboardType = dm.inputType.keyboardType
        textField.isSecureTextEntry = dm.inputType == .password
        textField.accessibilityIdentifier = dm.accessibilityIdentifier
        textField.textContentType = .oneTimeCode // force disable strong password
        textField.autocorrectionType = dm.inputType.autocorrectionType
        textField.autocapitalizationType = dm.inputType.autoCapitalization
        textField.returnKeyType = dm.returnKeyType
        textField.isEnabled = dm.isEnabled
        textField.delegate = self
    }
    
    func clearContent() {
        titleLabel.attributedText = nil
        subtitleLabel.text = nil
        textField.text = nil
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            let text = textField.text,
            let textRange = Range(range, in: text)
        else {
            return false
        }
        
        delegate?.textFieldUpdated(with: text.replacingCharacters(in: textRange, with: string), for: self)
        return true
    }
}
