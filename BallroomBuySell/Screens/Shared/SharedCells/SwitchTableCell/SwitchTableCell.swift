//
//  SwitchTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-26.
//

import UIKit

protocol SwitchCellDelegate {
    func updateSwitchDetail(_ newValue: Bool, for cell: SwitchTableCell)
}

class SwitchTableCell: UITableViewCell, UITextViewDelegate, TableCellProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    var delegate: SwitchCellDelegate?
    
    static func registerCell(_ tableView: UITableView) {
          let identifier = String(describing: SwitchTableCell.self)
          tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView) -> SwitchTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwitchTableCell.self)) as? SwitchTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: SwitchCellDM) {
        clearContent()
        
        titleLabel.text = dm.title
        toggle.setOn(dm.isSelected, animated: false)
        toggle.isEnabled = dm.isEnabled
    }
    
    func clearContent() {
        titleLabel.text = ""
        toggle.setOn(false, animated: false)
        //toggle.removeBorder() // TODO! do we want a toggle?
    }
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        delegate?.updateSwitchDetail(sender.isOn, for: self)
        applyToggleBorderTheme()
    }
    
    // MARK: Private Helpers
    private func applyToggleBorderTheme() {
        //toggle.addBorder(withColor: toggle.isOn ? ThemeManager.sharedInstance.theme.confirmationColor : ThemeManager.sharedInstance.theme.primaryTextColor)
    }
}
