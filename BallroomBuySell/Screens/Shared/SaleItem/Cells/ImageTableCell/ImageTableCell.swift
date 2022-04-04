//
//  ImageTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

protocol ImageCellDelegate {
    func addImage(_ data: Data)
    func deleteImage(at index: Int)
}

extension ImageCellDelegate { // for view only case no need for image update methods
    func addImage(_ data: Data){}
    func deleteImage(at index: Int){}
}

class ImageTableCell: UITableViewCell, TableCellProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var maxImageCount = 0
    private let imageWidth = 200
    private var imagesList = [Data]()
    private var isEditable = true
    var delegate: (ImageCellDelegate & UIViewController)?
    
    // MARK: - Life Cycle
    static func registerCell(for tableView: UITableView) {
        let identifier = String(describing: ImageTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(for tableView: UITableView) -> ImageTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableCell.self)) as? ImageTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        ImageCollectionCell.registerCell(for: cell.collectionView)
        return cell
    }
    
    func configureCell(with dm: ImageCellDM) {
        clearContent()
        
        titleLabel.attributedText = dm.title.attributedText(color: Theme.Color.primaryText.value, required: dm.showRequiredAsterisk)
        imagesList = dm.images
        maxImageCount = dm.maxImages
        isEditable = dm.editable
        
        collectionView.reloadData()
        collectionViewHeight.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        layoutIfNeeded()
    }
    
    func clearContent() {
        titleLabel.attributedText = nil
        imagesList.removeAll()
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesList.count + (isEditable && imagesList.count < maxImageCount ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ImageCollectionCell.createCell(for: collectionView, at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: indexPath.row < imagesList.count ? imagesList[indexPath.row] : nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        
        let actionItems = collectionView.numberOfItems(inSection: 0) - 1 == indexPath.row && isEditable && imagesList.count < maxImageCount ? getEmptyActionSheetItems() : getNonEmptyActionSheetItems(indexPath)
        delegate.showActionSheetOrPopover(message: LocalizedString.string("sale.item.images.actions"), alertActions: actionItems)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        let normalizedImage = normalizedImage(selectedImage)
        let resizedImage = resize(sourceImage: normalizedImage, newWidth: CGFloat(imageWidth))
        
        picker.dismiss(animated: true, completion: nil)
        if let imageData = resizedImage.pngData() {
            delegate?.addImage(imageData)
        }
    }
    
    // MARK: - Private Helpers
    private func getEmptyActionSheetItems() -> [UIAlertAction] {
        var actionItems = [UIAlertAction]()
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.camera.app"), style: .default) { _ in
            MediaManager.displayCamera(self, displayingVC: self.delegate)
        })
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.photos.app"), style: .default) { _ in
            MediaManager.displayGallery(self, displayingVC: self.delegate)
        })
        
        return actionItems
    }
    
    private func getNonEmptyActionSheetItems(_ indexPath: IndexPath) -> [UIAlertAction] {
        let imageData = imagesList[indexPath.row]
        var actionItems = [UIAlertAction]()
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.view"), style: .default) { _ in
            self.displayImage(imageData)
        })
        
        if isEditable {
            actionItems.append(UIAlertAction(title: LocalizedString.string("generic.remove"), style: .destructive) { _ in
                self.delegate?.deleteImage(at: indexPath.row)
            })
        }
        
        return actionItems
    }
    
    private func displayImage(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        let imageViewer = ImageViewer.createViewController(image)
        imageViewer.modalPresentationStyle = .fullScreen
        self.delegate?.present(imageViewer, animated: true, completion: nil)
    }
    
    private func normalizedImage(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        if let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        
        return UIImage()
    }
    
    private func resize(sourceImage: UIImage, newWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = newWidth / oldWidth
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
