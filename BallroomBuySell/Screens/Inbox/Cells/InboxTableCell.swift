//
//  InboxTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

class InboxTableCell: UITableViewCell, TableCellProtocol {
    @IBOutlet weak var saleItemImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var messagePreviewLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    static func createCell(_ tableView: UITableView) -> InboxTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxTableCell.self)) as? InboxTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: InboxCellDM) {
        clearContent()
        
        saleItemImage.image = dm.saleItemImage
        userLabel.text = dm.userDisplayName
        itemLabel.text = dm.saleItem
        messagePreviewLabel.text = dm.messagePreview
    }
    
    func clearContent() {
        userLabel.text = ""
        itemLabel.text = ""
        messagePreviewLabel.text = ""
    }
}
