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
    
    static func downloadImages(_ imageURLs: [String]) async -> [Image] {
        var images = [Image]()
        
        for imageURL in imageURLs {
            do {
                let imageData = try await FileSystemManager.getFile(at: imageURL)
                images.append(Image(url: imageURL, data: imageData))
            } catch {
                continue
            }
        }
        
        return images
    }
}
