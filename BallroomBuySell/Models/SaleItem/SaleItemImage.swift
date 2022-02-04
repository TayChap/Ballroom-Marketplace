//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

class SaleItemImage: Codable { // Image is a class to make fetching and updating images asynchronously more managable
    let url: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(url: String, data: Data?) {
        self.url = url
        self.data = data
    }
    
    // MARK: - Public Helpers
    static func uploadSaleItemImages(_ images: [SaleItemImage]) {
        for image in images {
            guard let data = image.data else {
                return
            }
            
            FileSystemManager.putFile(data, at: image.url)
        }
    }
    
    /// This method retrieves and adds image data to the images array based on the image URLs
    static func downloadSaleItemImages(_ images: [SaleItemImage], _ completion: @escaping () -> Void) {
        for image in images {
            FileSystemManager.getFile(at: image.url) { data in
                image.data = data
                if images.allSatisfy({ $0.data != nil }) {
                    completion()
                }
            }
        }
    }
}
