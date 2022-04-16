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
    
    static func registerCell(for collectionView: UICollectionView)
    static func createCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> Cell?
    func configureCell(with dm: DataModal)
    func clearContent()
    
    // MARK: - Accessibility
    func setAccessibilityId(_ accessibilityId: String)
}

extension  CollectionCellProtocol {
    static func registerCell(for collectionView:  UICollectionView) {}
    
    // MARK: - Accessibility
    func setAccessibilityId(_ accessibilityId: String) {
        accessibilityIdentifier = accessibilityId
    }
}
