//
//  InboxEmptyTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-31.
//

import UIKit

class InboxEmptyTableCell: UITableViewCell, TableCellProtocol {
    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    static func createCell(_ tableView: UITableView) -> InboxEmptyTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxEmptyTableCell.self)) as? InboxEmptyTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ title: String) {
        clearContent()
        emptyMessageLabel.text = title
    }
    
    func clearContent() {
        emptyMessageLabel.text = ""
    }
}
