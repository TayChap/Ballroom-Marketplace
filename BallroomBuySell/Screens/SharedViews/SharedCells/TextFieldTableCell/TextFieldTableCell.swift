//
//  TextFieldTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

protocol TextFieldCellDelegate {
    
}

class TextFieldTableCell: UITableViewCell, TableCellProtocol, UITextFieldDelegate {
    enum InputType {
        case standard, passwordMasked, passwordUnmasked , email
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .standard, .passwordMasked, .passwordUnmasked: return .default
            case .email: return .emailAddress
            }
        }
        
        var autoCapitalization: UITextAutocapitalizationType {
            switch self {
            case .passwordMasked, .passwordUnmasked, .email: return .none
            default: return .sentences
            }
        }
        
        var autocorrectionType: UITextAutocorrectionType {
            switch self {
            case .passwordMasked, .passwordUnmasked, .email: return .no
            default: return .yes
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    // TODO! add action button for mask / unmask
    @IBOutlet weak var underlineView: UIView!
    
    var delegate: TextFieldCellDelegate?
    
    // MARK: - Lifecycle Methods
    static func registerCell(_ tableView: UITableView) {
        let identifier = String(describing: TextFieldTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView) -> TextFieldTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldTableCell.self)) as? TextFieldTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: TextFieldCellDM) {
        clearContent()
        
        titleLabel.text = dm.title
        
        subtitleLabel.text = dm.subtitle
        subtitleLabel.isHidden = dm.subtitle.isEmpty
        
        textField.text = dm.detail
        textField.keyboardType = dm.type.keyboardType
        textField.isSecureTextEntry = dm.type == .passwordMasked
        textField.textContentType = .oneTimeCode // force disable strong password
        textField.autocorrectionType = dm.type.autocorrectionType
        textField.autocapitalizationType = dm.type.autoCapitalization
        textField.returnKeyType = dm.returnKeyType
        textField.delegate = self
        
//        if let actionImage = dm.actionButtonImage {
//            actionButton.isHidden = false
//            actionButton.setImage(actionImage)
//        }
    }
    
    func clearContent() {
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        textField.text = nil
    }
    
    // MARK: - TextFieldDelegate
    // ...
}
