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
    private var imageURL = ""
    
    static func createCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> CategoryCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionCell.self), for: indexPath) as? CategoryCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: CategoryCollectionCellDM) {
        clearContent()
        
        categoryImageView.roundViewCorners(5.0)
        imageURL = dm.imageURL
        ImageManager.sharedInstance.downloadImage(at: dm.imageURL) { [weak self] image in // weak self because cell might be deallocated before network call returns
            guard self?.imageURL == dm.imageURL else { // check if captured imageURL is same as current cell
                return
            }
            
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
