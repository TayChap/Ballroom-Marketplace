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
        
        coverImage.roundViewCorners(5.0)
        imageURL = dm.imageURL
        ImageManager.sharedInstance.downloadImage(at: dm.imageURL) { [weak self] image in // weak self because cell might be deallocated before network call returns
            guard self?.imageURL == dm.imageURL else { // check if captured imageURL is same as current cell
                return
            }
            
            self?.coverImage.image = UIImage(data: image)
        }
        
        priceLabel.text = dm.price
        detailLabel.text = dm.location
        
        applyRoundedCorners()
    }
    
    func clearContent() {
        coverImage.image = nil
        priceLabel.text = ""
        detailLabel.text = ""
    }
}
