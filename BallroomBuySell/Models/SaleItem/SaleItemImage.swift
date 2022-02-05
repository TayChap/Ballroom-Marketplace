//
//  SaleItemImage.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

struct SaleItemImage: Codable {
    let id: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
    }
    
    // MARK: - Public Helpers
    static func uploadImages(_ images: [SaleItemImage]) {
        for image in images {
            guard let data = image.data else {
                return
            }
            
            FileSystemManager.putFile(data, at: image.id)
        }
    }
    
    static func downloadImages(_ imageIDs: [String], _ completion: @escaping (_ images: [SaleItemImage]) -> Void) {
        var fetchedImages = [SaleItemImage]()
        func checkCompletion() {
            if fetchedImages.count == imageIDs.count {
                completion(fetchedImages)
            }
        }
        
        checkCompletion()
        
        for imageID in imageIDs {
            FileSystemManager.getFile(at: getURL(imageID)) { data in
                fetchedImages.append(SaleItemImage(id: imageID, data: data))
                checkCompletion()
            }
        }
    }
    
    // MARK: - Private Methods
    private static func getURL(_ id: String) -> String {
        "saleItems/\(id)"
    }
}
