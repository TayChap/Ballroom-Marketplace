//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import FirebaseStorage

struct ImageManager {
    var storage: Storage {
        Storage.storage()
    }
    
    // MARK: - Public Helpers
    func uploadImage(_ image: Data) {
        let reference = storage.reference(forURL: "images/\(UUID().uuidString)")
        reference.putData(image, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                // TODO! an error occurred
                return
            }
        }
    }
    
    func downloadImage(at url: String, _ completion: @escaping (_ image: UIImage) -> Void) {
        let reference = storage.reference(forURL: url)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in // Download in memory with a max size of 1MB (1 * 1024 * 1024 bytes)
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return // TODO!
            }
            
            completion(image)
        }
    }
}
