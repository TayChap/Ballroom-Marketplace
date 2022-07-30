//
//  PhotoPicker.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-27.
//

import PhotosUI

struct PhotoPicker {
    static let userAddedImageWidth = 800.0 // size for ALL user added images in the app
    
    static func getConfiguration(with maxSelections: Int) -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        configuration.preferredAssetRepresentationMode = .current // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.selectionLimit = maxSelections // Set the selection limit to enable multiselection.
        
        if #available(iOS 15, *) {
            configuration.selection = .ordered
        }
        
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
            let resizedImage = normalizedImage.resize(newWidth: PhotoPicker.userAddedImageWidth)
            
            guard let data = resizedImage.pngData() else {
                completion(nil, NetworkError.internalSystemError)
                return
            }
            
            completion(data, nil)
        }
        //            }
    }
}
