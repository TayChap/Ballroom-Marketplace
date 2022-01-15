//
//  CollectionCellProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

protocol CollectionCellProtocol: UICollectionViewCell {
    associatedtype DataModal
    associatedtype Cell: UICollectionViewCell
    
    static func registerCell(_ collectionView: UICollectionView)
    static func createCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> Cell?
    func configureCell(_ dm: DataModal)
    func clearContent()
    
    // MARK: - Accessibility
    func setAccessibilityId(_ accessibilityId: String)
}

extension  CollectionCellProtocol {
    static func registerCell(_ collectionView:  UICollectionView) {}
    
    // MARK: - Accessibility
    func setAccessibilityId(_ accessibilityId: String) {
        accessibilityIdentifier = accessibilityId
    }
}
