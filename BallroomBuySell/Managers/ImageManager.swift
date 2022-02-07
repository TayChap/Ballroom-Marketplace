//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-03.
//

import Foundation

class ImageManager {
    static let sharedInstance = ImageManager()
    
    struct ImageRequestObject {
        var url: String
        var success: (_ imageData: Data) -> Void
    }
    
    // MARK: - Asynchronous Down
    private var requestQueue = [ImageRequestObject]()
    private var currentCallCount = 0 // active SERVER requests for images
    
    // MARK: - Configuration Constants
    private let maxQueueSize = 15
    private let maxSimultaneousCalls = 10
    
    // MARK: - Private Init
    private init() {} // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func downloadImage(at url: String, _ completion: @escaping (_ imageData: Data) -> Void) {
        if requestQueue.count > maxQueueSize {
            requestQueue.removeFirst()
        }
        
        requestQueue.append(ImageRequestObject(url: url, success: completion))
        if currentCallCount < maxSimultaneousCalls {
            let imageRequestObject = requestQueue.removeLast()
            currentCallCount += 1
            FileSystemManager.getFile(at: imageRequestObject.url) { data in
                self.currentCallCount -= 1
                completion(data)
            }
        }
    }
}
