//
//  CategoryCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-27.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell, CollectionCellProtocol  {
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
        
        categoryLabel.text = dm.categoryTitle
        
        applyRoundedCorners()
    }
    
    func clearContent() {
        categoryLabel.text = ""
    }
}
