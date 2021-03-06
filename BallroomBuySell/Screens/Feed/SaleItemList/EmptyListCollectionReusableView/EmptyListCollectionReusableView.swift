//
//  EmptyListCollectionReusableView.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-31.
//

import UIKit

class EmptyListCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var emptyListMessage: UILabel!
    
    static func registerCell(for collectionView: UICollectionView) {
        let identifier = String(describing: EmptyListCollectionReusableView.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    static func createCell(for collectionView: UICollectionView, ofKind kind: String, at indexPath: IndexPath) -> EmptyListCollectionReusableView? {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmptyListCollectionReusableView.self), for: indexPath) as? EmptyListCollectionReusableView else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: String) {
        clearContent()
        emptyListMessage.text = dm
    }
    
    func clearContent() {
        emptyListMessage.text = ""
    }
}
