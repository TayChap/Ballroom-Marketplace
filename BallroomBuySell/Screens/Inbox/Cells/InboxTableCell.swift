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
        
        ImageManager.sharedInstance.downloadImage(at: dm.imageURL) { [weak self] image in // weak self because cell might be deallocated before network call returns
            self?.saleItemImage.image = UIImage(data: image)
        }
        
        userLabel.text = dm.userDisplayName
        messagePreviewLabel.text = dm.messagePreview
    }
    
    func clearContent() {
        saleItemImage.image = nil
        userLabel.text = ""
        itemLabel.text = ""
        messagePreviewLabel.text = ""
    }
}
