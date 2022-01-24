//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import FirebaseStorage

struct ImageManager {
    static let sharedInstance = ImageManager()
    var storage: Storage {
        Storage.storage()
    }
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func uploadImagesAsynchronously(_ images: [Image]) {
        for image in images {
            storage.reference().child(image.url).putData(image.data ?? Data(), metadata: nil) // TODO guard for data
        }
    }
    
    func downloadImage(at url: String, _ completion: @escaping (_ image: Data) -> Void) {
        let reference = storage.reference().child(url)
        reference.getData(maxSize: 1 * 1024 * 1024 * 10) { data, error in // Download in memory with a max size of 10MB (1 * 1024 * 1024 bytes)
            guard let data = data else {
                return // TODO!
            }
            
            completion(data)
        }
    }
}
