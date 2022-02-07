//
//  SaleItemImage.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct Image: Codable {
    private let id: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
    }
    
    // MARK: - Public Helpers
    static func uploadImages(_ images: [Image]) {
        for image in images {
            guard let data = image.data else {
                return
            }
            
            FileSystemManager.putFile(data, at: image.id)
        }
    }
    
    static func downloadImages(_ imageIDs: [String], _ completion: @escaping (_ images: [Image]) -> Void) {
        var fetchedImages = [Image]()
        func checkCompletion() {
            if fetchedImages.count == imageIDs.count {
                completion(fetchedImages)
            }
        }
        
        checkCompletion()
        
        for imageID in imageIDs {
            FileSystemManager.getFile(at: getURL(imageID)) { data in
                fetchedImages.append(Image(id: imageID, data: data))
                checkCompletion()
            }
        }
    }
    
    // MARK: - Private Methods
    private static func getURL(_ id: String) -> String {
        "saleItems/\(id)"
    }
}
