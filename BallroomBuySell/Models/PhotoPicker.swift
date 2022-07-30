//
//  PhotoPicker.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-27.
//

import PhotosUI

struct PhotoPicker {
    static func getConfiguration() -> PHPickerConfiguration {
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
        
        return configuration
    }
    
    static func getImagesResults(_ results: [PHPickerResult]) async -> [Data] {
        var imagesData = [Data]()
        
        for result in results {
            do {
                let imageData = try await getImageResult(result)
                imagesData.append(imageData)
            } catch {
                continue
            }
        }
        
        return imagesData
    }
    
    private static func getImageResult(_ result: PHPickerResult) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            getImageResult(result) { data, error in
                guard let data = data, error == nil else {
                    continuation.resume(throwing: NetworkError.internalSystemError)
                    return
                }
                
                continuation.resume(returning: data)
            }
        }
    }
    
    private static func getImageResult(_ result: PHPickerResult, _ completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        //            if result.itemProvider.canLoadObject(ofClass: UIImage.self) { // TODO! deal with so-called live images
        result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage, error == nil else {
                completion(nil, NetworkError.internalSystemError)
                return
            }
            
            let normalizedImage = image.normalizedImage()
            let resizedImage = normalizedImage.resize(newWidth: 800) // TODO! width
            
            guard let data = resizedImage.pngData() else {
                completion(nil, NetworkError.internalSystemError)
                return
            }
            
            completion(data, nil)
        }
        //            }
    }
}
