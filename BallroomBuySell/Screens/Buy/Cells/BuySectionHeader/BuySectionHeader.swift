//
//  BuySectionHeader.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-27.
//

import UIKit

class BuySectionHeader: UICollectionReusableView {
    @IBOutlet weak var buySectionLabel: UILabel!
    
    static func registerCell(_ collectionView: UICollectionView) {
        let identifier = String(describing: BuySectionHeader.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    static func createCell(_ collectionView: UICollectionView, ofKind kind: String, for indexPath: IndexPath) -> BuySectionHeader? {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BuySectionHeader.self), for: indexPath) as? BuySectionHeader else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ dm: String) {
        clearContent()
        buySectionLabel.text = dm
    }
    
    func clearContent() {
        buySectionLabel.text = ""
    }
}
