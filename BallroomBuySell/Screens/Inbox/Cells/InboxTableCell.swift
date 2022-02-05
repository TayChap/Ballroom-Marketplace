//
//  InboxTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

class InboxTableCell: UITableViewCell, TableCellProtocol {
    @IBOutlet weak var saleItemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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
        
        itemLabel.text = dm.title
        messagePreviewLabel.attributedText = NSAttributedString(string: "\(dm.lastMessage.displayName): \(dm.lastMessage.content)")
        dateLabel.text = dm.lastMessage.sentDate.toReadableString()
    }
    
    func clearContent() {
        saleItemImage.image = nil
        itemLabel.text = ""
        messagePreviewLabel.attributedText = nil
    }
}
