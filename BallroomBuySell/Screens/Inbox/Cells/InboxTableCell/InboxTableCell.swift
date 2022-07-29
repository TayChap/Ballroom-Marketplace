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
    private var imageFetchingTask = Task {}
    
    // MARK: - Lifecycle Methods
    static func createCell(for tableView: UITableView) -> InboxTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxTableCell.self)) as? InboxTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: InboxCellDM) {
        clearContent()
        
        saleItemImage.roundViewCorners(5.0)
        titleLabel.text = dm.title
        dateLabel.text = dm.date?.toReadableString()
        detailLabel.text = dm.detail
        
        imageFetchingTask = Task {
            if let image = await Image.downloadImages([dm.imageURL]).first?.data {
                saleItemImage.image = UIImage(data: image)
            }
        }
    }
    
    func clearContent() {
        saleItemImage.image = nil
        titleLabel.text = ""
        dateLabel.text = ""
        detailLabel.text = ""
        imageFetchingTask.cancel()
    }
}
