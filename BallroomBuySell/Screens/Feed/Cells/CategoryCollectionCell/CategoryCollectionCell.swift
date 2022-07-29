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
    private var imageFetchingTask = Task {}
    
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
        categoryLabel.text = dm.categoryTitle
        applyRoundedCorners()
        
        imageFetchingTask = Task {
            if let image = await Image.downloadImages([dm.imageURL]).first?.data {
                categoryImageView.image = UIImage(data: image)
            }
        }
    }
    
    func clearContent() {
        categoryLabel.text = ""
        categoryImageView.image = nil
        imageFetchingTask.cancel()
    }
}
