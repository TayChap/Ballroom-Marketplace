//
//  Image.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-23.
//

import Foundation

class Image: Codable { // Image is a class to make fetching and updating images asynchronously more managable
    let url: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(url: String, data: Data?) {
        self.url = url
        self.data = data
    }
}
