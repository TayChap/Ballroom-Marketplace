//
//  ImageTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import PhotosUI

protocol ImageCellDelegate {
    func addImages(_ images: [Data])
    func deleteImage(at index: Int)
}

extension ImageCellDelegate { // for view only case no need for image update methods
    func addImages(_ images: [Data]){}
    func deleteImage(at index: Int){}
}

class ImageTableCell: UITableViewCell, TableCellProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var maxImageCount = 0
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
        guard let delegate = delegate, isEditable else {
            displayImage(indexPath.row)
            return
        }
        
        let actionItems = collectionView.numberOfItems(inSection: 0) - 1 == indexPath.row && isEditable && imagesList.count < maxImageCount ? getEmptyActionSheetItems() : getNonEmptyActionSheetItems(indexPath)
        delegate.showActionSheetOrPopover(message: LocalizedString.string("sale.item.images.actions"), alertActions: actionItems)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        let normalizedImage = selectedImage.normalizedImage()
        let resizedImage = normalizedImage.resize(newWidth: PhotoPicker.userAddedImageWidth)
        
        if let imageData = resizedImage.pngData() {
            delegate?.addImages([imageData])
        }
    }
    
    // MARK: - PHPickerViewController Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        Task {
            delegate?.addImages(await PhotoPicker.getImagesResults(results))
        }
    }
    
    // MARK: - Private Helpers
    /// Return all action items when the user wants to add an image
    /// - Returns: set of actions to add a image
    private func getEmptyActionSheetItems() -> [UIAlertAction] {
        var actionItems = [UIAlertAction]()
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.camera.app"), style: .default) { _ in
            Camera.displayCamera(self, displayingVC: self.delegate)
        })
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.photos.app"), style: .default) { _ in
            let picker = PHPickerViewController(configuration: PhotoPicker.getConfiguration(with: self.maxImageCount - self.imagesList.count))
            picker.delegate = self
            self.delegate?.present(picker, animated: true)
        })
        
        return actionItems
    }
    
    /// Return all action items when the user wants to interact with an image
    /// - Parameter indexPath: indexPath referring to the index of the image
    /// - Returns: set of actions to interact with an image
    private func getNonEmptyActionSheetItems(_ indexPath: IndexPath) -> [UIAlertAction] {
        var actionItems = [UIAlertAction]()
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.view"), style: .default) { _ in
            self.displayImage(indexPath.row)
        })
        
        if isEditable {
            actionItems.append(UIAlertAction(title: LocalizedString.string("generic.remove"), style: .destructive) { _ in
                self.delegate?.deleteImage(at: indexPath.row)
            })
        }
        
        return actionItems
    }
    
    /// Display image to user
    /// - Parameter imageData: image to display
    private func displayImage(_ index: Int) {
        let imageViewer = ImageViewer.createViewController(imagesList.map({ UIImage(data: $0) ?? UIImage() }), at: index)
        delegate?.present(imageViewer, animated: true)
    }
}
