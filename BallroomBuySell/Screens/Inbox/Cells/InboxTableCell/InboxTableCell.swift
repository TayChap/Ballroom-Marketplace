//
//  InboxTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

class InboxTableCell: UITableViewCell, TableCellProtocol {
    @IBOutlet weak var saleItemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
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
        
        titleLabel.text = dm.title
        dateLabel.text = dm.date?.toReadableString()
        detailLabel.text = dm.detail
    }
    
    func clearContent() {
        saleItemImage.image = nil
        titleLabel.text = ""
        dateLabel.text = ""
        detailLabel.text = ""
    }
}
