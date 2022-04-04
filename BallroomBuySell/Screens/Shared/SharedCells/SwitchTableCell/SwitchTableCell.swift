//
//  SwitchTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-26.
//

import UIKit

protocol SwitchCellDelegate {
    func updateSwitchDetail(with isOn: Bool, for cell: SwitchTableCell)
}

class SwitchTableCell: UITableViewCell, UITextViewDelegate, TableCellProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    var delegate: SwitchCellDelegate?
    
    static func registerCell(for tableView: UITableView) {
          let identifier = String(describing: SwitchTableCell.self)
          tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(for tableView: UITableView) -> SwitchTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwitchTableCell.self)) as? SwitchTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: SwitchCellDM) {
        clearContent()
        
        titleLabel.text = dm.title
        toggle.setOn(dm.isSelected, animated: false)
        toggle.isEnabled = dm.isEnabled
    }
    
    func clearContent() {
        titleLabel.text = ""
        toggle.setOn(false, animated: false)
    }
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        delegate?.updateSwitchDetail(with: sender.isOn, for: self)
    }
}
