//
//  SaleItemCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

class SaleItemCollectionCell: UICollectionViewCell, CollectionCellProtocol {
    
    
    static func registerCell(_ collectionView: UICollectionView) {
        let identifier = String(describing: SaleItemCollectionCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    static func createCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> SaleItemCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SaleItemCollectionCell.self), for: indexPath) as? SaleItemCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: SaleItemCellDM) {
        clearContent()
        
        // TODO!
    }
    
    func clearContent() {
        // TODO!
    }
    
}
