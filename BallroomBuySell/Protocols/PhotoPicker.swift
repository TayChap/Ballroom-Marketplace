//
//  PhotoPicker.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-27.
//

import PhotosUI

protocol PhotoPicker: PHPickerViewControllerDelegate {
    var imageWidth: Double { get }
    func didFinishPicking(_ imagesData: [Data])
}

extension PhotoPicker {
    func presentPicker(_ owner: UIViewController?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        
        // Set the selection behavior to respect the user’s selection order.
//        configuration.selection = .ordered // TODO! consider adding when drop iOS 14 support
        
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 0
        
        // Set the preselected asset identifiers with the identifiers that the app tracks.
//        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers // TODO! evaluate if relevant here?
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        owner?.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        Task { // TODO! evaluate
//            do {
//                for result in results {
//                    let x = try await result.itemProvider.loadItem(forTypeIdentifier: String(describing: UIImage.self)) as? UIImage
//                }
//            } catch {
//                print("parsing_error")
//            }
//        }
        
        var imagesData = [Data]()
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage, error == nil else {
                        return
                    }
                    
                    let normalizedImage = image.normalizedImage()
                    let resizedImage = normalizedImage.resize(newWidth: self.imageWidth)
                    
                    guard let data = resizedImage.pngData() else {
                        return
                    }
                    
                    imagesData.append(data)
                }
            }
        }
    }
}
