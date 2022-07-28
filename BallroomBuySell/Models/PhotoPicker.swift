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
    
    static func getImageResults(_ results: [PHPickerResult]) async -> [Data] {
//        Task { // TODO! evaluate
//            do {
//                for result in results {
//                    let x = try await result.itemProvider.loadItem(forTypeIdentifier: String(describing: UIImage.self)) as? UIImage
//                }
//            } catch {
//                print("parsing_error")
//            }
//        }
        [Data]()
    }
}
