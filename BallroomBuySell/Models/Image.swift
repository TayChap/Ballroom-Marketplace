//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct Image: Codable {
    var url = "\(Environment.current.rawValue)/images/\(UUID().uuidString)"
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case url // omit data in Firestore (stored on cloud storage instead)
    }
    
    // MARK: - Public Helpers
    static func uploadImages(_ images: [Image]) {
        for image in images {
            guard let data = image.data else {
                return
            }
            
            FileSystemManager.putFile(data, at: image.url)
        }
    }
    
    static func downloadImages(_ imageURLs: [String], _ completion: @escaping (_ images: [Image]) -> Void) {
        var fetchedImages = [Image]()
        func checkCompletion() {
            if fetchedImages.count == imageURLs.count {
                completion(fetchedImages)
            }
        }
        
        checkCompletion()
        
        for imageURL in imageURLs {
            FileSystemManager.getFile(at: imageURL) { data in
                fetchedImages.append(Image(url: imageURL, data: data))
                checkCompletion()
            }
        }
    }
}
