//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import FirebaseStorage

class ImageManager {
    static let sharedInstance = ImageManager()
    var storage: Storage {
        Storage.storage()
    }
    
    // MARK: - Asynchronous Down
    private var requestQueue = [ImageRequestObject]()
    private var currentCallCount = 0 // active SERVER requests for images
    
    // MARK: - Configuration Constants
    private let localImageFolder = "images/"
    private let maxQueueSize = 15
    private let maxSimultaneousCalls = 10
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func uploadImages(_ images: [Image]) {
        for image in images {
            guard let data = image.data else {
                return
            }
            
            storage.reference().child(image.url).putData(data)
        }
    }
    
    /// This method retrieves and adds image data to the images array based on the image URLs
    func downloadImages(_ images: [Image], _ completion: @escaping () -> Void) {
        for image in images {
            if let imageData = getFile(at: getFileURL(image.url)) {
                image.data = imageData
                continue
            }
            
            let fileURL = getFileURL(image.url)
            storage.reference().child(image.url).write(toFile: fileURL) { _ , error in
                guard let data = self.getFile(at: fileURL), error == nil else {
                    return // TODO! error
                }
                
                image.data = data
                
                if images.allSatisfy({ $0.data != nil }) {
                    completion()
                }
            }
        }
        
        if images.allSatisfy({ $0.data != nil }) {
            completion()
        }
    }
    
    func downloadImageAsynchronously(at url: String, _ completion: @escaping (_ imageData: Data) -> Void) {
        if let imageData = getFile(at: getFileURL(url)) {
            completion(imageData)
            return
        }
        
        if requestQueue.count > maxQueueSize {
            requestQueue.removeFirst()
        }
        
        requestQueue.append(ImageRequestObject(url: url, success: completion))
        if currentCallCount < maxSimultaneousCalls { // TODO! what if too many calls?
            fetchImages()
        }
    }
    
    // MARK: - Private Helpers
    /// Pulls the first request object on the queue and downloads an image then calls the success or failure if provided. If the queue isn't empty will recursively call fetch image
    private func fetchImages() {
        let imageRequestObject = requestQueue.removeLast()
        currentCallCount += 1
        
        let fileURL = getFileURL(imageRequestObject.url)
        storage.reference().child(imageRequestObject.url).write(toFile: fileURL) { _ , error in
            guard let data = self.getFile(at: fileURL), error == nil else {
                return // TODO! error
            }
            
            self.currentCallCount -= 1
            imageRequestObject.success(data)
        }
    }
    
    private func getFileURL(_ url: String) -> URL {
        let imageFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(localImageFolder).absoluteURL ?? URL(fileURLWithPath: "")
        return imageFolder.appendingPathComponent(URL(string: url)?.lastPathComponent ?? "")
    }
    
    private func getFile(at fileURL: URL) -> Data? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return data
    }
}
