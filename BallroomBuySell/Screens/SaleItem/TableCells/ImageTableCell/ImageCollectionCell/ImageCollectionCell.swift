//
//  ImageCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell, CollectionCellProtocol {
    @IBOutlet weak var imageView: UIImageView!
    
    private let emptyCellImage = UIImage(systemName: "plus")
    
    static func registerCell(_ collectionView: UICollectionView) {
        let identifier = String(describing: ImageCollectionCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    static func createCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> ImageCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionCell.self), for: indexPath) as? ImageCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ image: Data?) {
        clearContent()
        
        guard
            let data = image,
            let image = UIImage(data: data)
        else {
            imageView.image = UIImage(systemName: "plus")
            return
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    func clearContent() {
        imageView.image = nil
        imageView.contentMode = .center
    }
}
