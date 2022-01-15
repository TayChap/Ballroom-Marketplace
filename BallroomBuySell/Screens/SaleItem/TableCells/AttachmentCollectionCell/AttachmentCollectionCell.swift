//
//  AttachmentCollectionCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

class AttachmentCollectionCell: UICollectionViewCell, CollectionCellProtocol {
    @IBOutlet weak var imageView: UIImageView!
    
    private let emptyCellImage = UIImage(systemName: "plus")
    
    static func registerCell(_ collectionView: UICollectionView) {
        let identifier = String(describing: AttachmentCollectionCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    static func createCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> AttachmentCollectionCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AttachmentCollectionCell.self), for: indexPath) as? AttachmentCollectionCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(_ attachment: Data?) {
        clearContent()
        
        guard
            let data = attachment,
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
