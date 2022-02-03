//
//  ImageTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

protocol ImageTableCellDelegate {
    func newImage(_ data: Data)
    func deleteImage(at index: Int)
}

class ImageTableCell: UITableViewCell, TableCellProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var maxImageCount = 0
    private let maxTotalImageSize = 9.0 // in MBs
    private var imagesList = [Data]()
    private var isEditable = true
    var delegate: (ImageTableCellDelegate & UIViewController)? // TODO! why UIViewController?
    
    // MARK: - Life Cycle
    static func registerCell(_ tableView: UITableView) {
        let identifier = String(describing: ImageTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView) -> ImageTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableCell.self)) as? ImageTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        ImageCollectionCell.registerCell(cell.collectionView)
        return cell
    }
    
    func configureCell(_ dm: ImageCellDM) {
        clearContent()
        
        titleLabel.text = dm.title
        imagesList = dm.images
        maxImageCount = dm.maxImages
        isEditable = dm.editable
        
        collectionView.reloadData()
        collectionViewHeight.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        layoutIfNeeded()
    }
    
    func clearContent() {
        titleLabel.text = ""
        imagesList.removeAll()
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesList.count + (isEditable && imagesList.count < maxImageCount ? 1 : 0) // TODO!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ImageCollectionCell.createCell(collectionView, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(indexPath.row < imagesList.count ? imagesList[indexPath.row] : nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        
        let actionItems = collectionView.numberOfItems(inSection: 0) - 1 == indexPath.row && isEditable && imagesList.count < maxImageCount ? getEmptyActionSheetItems() : getNonEmptyActionSheetItems(indexPath) // TODO!
        delegate.showActionSheetOrPopover(nil, "notes.attachment.actions", actionItems)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        let normalizedImage = normalizedImage(selectedImage)
        let resizedImage = resize(sourceImage: normalizedImage, newWidth: 750)
        
        picker.dismiss(animated: true, completion: nil)
        if let imageData = resizedImage.pngData(), !maxTotalFileSizeExceeded(imageData) {
            delegate?.newImage(imageData)
        }
    }
    
    // MARK: - Private Helpers
    private func getEmptyActionSheetItems() -> [UIAlertAction] {
        var actionItems = [UIAlertAction]()
        
        // Cancel
        actionItems.append(UIAlertAction(title: "generic.cancel", style: .cancel))
        
        // Camera
        actionItems.append(UIAlertAction(title: "select_camera", style: .default, handler: { (action) in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .camera
            controller.modalPresentationStyle = .fullScreen
            PermissionManager.checkCameraPermissions(owner: self.delegate) {
                DispatchQueue.main.async {
                    self.delegate?.present(controller, animated: true, completion: nil)
                }
            }
        }))
        
        // Gallery
        actionItems.append(UIAlertAction(title: "select_gallery", style: .default, handler: { (action) in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            controller.modalPresentationStyle = .fullScreen
            PermissionManager.checkPhotosPermissions(owner: self.delegate) {
                DispatchQueue.main.async {
                    self.delegate?.present(controller, animated: true, completion: nil)
                }
            }
        }))
        
        return actionItems
    }
    
    private func getNonEmptyActionSheetItems(_ indexPath: IndexPath) -> [UIAlertAction] {
        let imageData = imagesList[indexPath.row]
        var actionItems = [UIAlertAction]()
        
        actionItems.append(UIAlertAction(title: "generic.cancel", style: .cancel))
        
        actionItems.append(UIAlertAction(title: "notes.view.attachment", style: .default) { (action) in
            self.displayImage(imageData)
        })
        
        actionItems.append(UIAlertAction(title: "notes.remove.attachment", style: .destructive) { (action) in
            self.delegate?.deleteImage(at: indexPath.row)
        })
        
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
    
    private func maxTotalFileSizeExceeded(_ data: Data) -> Bool {
        let MB = 1000000.0
        let totalFileSize = imagesList.reduce(Double(data.count) / MB) { $0 + (Double($1.count) / MB) }
        if totalFileSize < maxTotalImageSize {
            return false
        }
        
        delegate?.showAlertWith(title: "generic.error", message: "notes.max.attachment.size.error.messsage")
        return true
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
