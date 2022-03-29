//
//  CategoryCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-27.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell, CollectionCellProtocol  {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static func createCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> CategoryCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionCell.self), for: indexPath) as? CategoryCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: CategoryCollectionCellDM) {
        clearContent()
        
        categoryImageView.roundViewCorners(5.0)
        ImageManager.sharedInstance.downloadImage(at: dm.imageURL) { [weak self] image in // weak self because cell might be deallocated before network call returns
            
            // TODO! evaluate if this check is required
            //if self?.imageURL == dm.imageURL { // check if captured imageURL is same as current cell
            
            self?.categoryImageView.image = UIImage(data: image)
        }
        
        categoryLabel.text = dm.categoryTitle
        applyRoundedCorners()
    }
    
    func clearContent() {
        categoryLabel.text = ""
        categoryImageView.image = nil
    }
}
