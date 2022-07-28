//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct Image: Codable {
    enum ImageCollection: String {
        case user, saleItems
        
        var url: String {
            "\(Environment.current.rawValue)/\(self.rawValue)/\(UUID().uuidString)"
        }
    }
    
    var url: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case url // omit data in Firestore (stored on cloud storage instead)
    }
    
    init(url: String, data: Data?) {
        self.url = url
        self.data = data
    }
    
    init(for collection: ImageCollection, data: Data?) {
        self.url = collection.url
        self.data = data
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
    
    static func downloadImages(_ imageURLs: [String], _ completion: @escaping (_ images: [Image]) -> Void) { // TODO! async
        var fetchedImages = [Image]()
        func checkCompletion() {
            if fetchedImages.count == imageURLs.count {
                completion(fetchedImages)
            }
        }
        
        checkCompletion()
        
        for imageURL in imageURLs {
            FileSystemManager.getFile(at: imageURL) { data, error in
                if error != nil {
                    fetchedImages.append(Image(url: UUID().uuidString, data: nil)) // if image not in DB, add empty image
                    checkCompletion()
                    return
                }
                
                fetchedImages.append(Image(url: imageURL, data: data))
                checkCompletion()
            }
        }
    }
}
