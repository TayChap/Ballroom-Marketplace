//
//  SaleItemCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

class SaleItemCollectionCell: UICollectionViewCell, CollectionCellProtocol {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    private var imageURL = ""
    
    static func registerCell(for collectionView: UICollectionView) {
        let identifier = String(describing: SaleItemCollectionCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    static func createCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> SaleItemCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SaleItemCollectionCell.self), for: indexPath) as? SaleItemCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: SaleItemCellDM) {
        clearContent()
        
        priceLabel.text = dm.price
        detailLabel.text = dm.location
        applyRoundedCorners()
        coverImage.roundViewCorners(5.0)
        
        imageURL = dm.imageURL
        Task {
            if let image = await Image.downloadImages([dm.imageURL]).first {
                if self.imageURL != image.url {
                    return
                }
                
                coverImage.image = UIImage(data: image.data ?? Data())
            }
        }
    }
    
    func clearContent() {
        coverImage.image = nil
        priceLabel.text = ""
        detailLabel.text = ""
        imageURL = ""
    }
}
