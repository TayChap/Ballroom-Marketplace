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
    static func registerCell(_ tableView: UITableView) {
        let identifier = String(describing: ButtonTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView) -> ButtonTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonTableCell.self)) as? ButtonTableCell else {
            assertionFailure("Can't find cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ title: String) {
        clearContent()
        button.setTitle(title)
    }
    
    func clearContent() {
        button.setTitle("")
    }
    
    // MARK: - IBActions
    @IBAction func buttonClicked() {
        delegate?.buttonClicked()
    }
}
