//
//  ButtonTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-02.
//

import UIKit

protocol ButtonCellDelegate: AnyObject { // AnyObject because it must be a class for weak delegate reference
    func buttonClicked()
}

class ButtonTableCell: UITableViewCell, TableCellProtocol {
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: ButtonCellDelegate? // weak to prevent strong reference cycle
    
    // MARK: - Lifecycle Methods
    static func registerCell(for tableView: UITableView) {
        let identifier = String(describing: ButtonTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(for tableView: UITableView) -> ButtonTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonTableCell.self)) as? ButtonTableCell else {
            assertionFailure("Can't find cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: ButtonCellDM) {
        clearContent()
        let color = dm.isDestructiveAction ? Theme.Color.destructive.value : Theme.Color.interactivity.value
        button.setTitle(dm.title,
                        with: color)
        button.addBorder(of: 2,
                         with: color.cgColor,
                         cornerRadius: 5.0)
    }
    
    func clearContent() {
        button.setTitle("")
    }
    
    // MARK: - IBActions
    @IBAction func buttonClicked() {
        delegate?.buttonClicked()
    }
}
