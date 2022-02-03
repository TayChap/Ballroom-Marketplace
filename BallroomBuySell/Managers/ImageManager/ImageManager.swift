//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//  Adapted from Lawrence Tran
//

import FirebaseStorage

class ImageManager {
    static let sharedInstance = ImageManager()
    var storage: Storage {
        Storage.storage()
    }
    
    private var requestQueue = [ImageRequestObject]()
    private let localImageFolder = "images/"
    private let maxQueueSize = 15
    private let maxSimultaneousCalls = 10
    private var currentCallCount = 0 // active SERVER requests for images
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func uploadImagesAsynchronously(_ images: [Image]) {
        for image in images {
            storage.reference().child(image.url).putData(image.data ?? Data(), metadata: nil) // TODO guard for data
        }
    }
    
    func downloadImage(at url: String, _ completion: @escaping (_ imageData: Data) -> Void) {
        createImageFolder()
        
        if let imageData = getFileLocally(url) {
            completion(imageData)
            return
        }
        
        // Removes first item if queue has exceeded size
        if requestQueue.count > maxQueueSize {
            requestQueue.removeFirst() // TODO! was removed last?
        }
        
        // Adds request into the queue and immediately fetches if current calls haven't exceeded allowed simutaneous calls
        requestQueue.insert(ImageRequestObject(url: url, success: completion), at: 0)
        if currentCallCount < maxSimultaneousCalls { // TOOD! what if it isn't?
            fetchImages()
        }
    }
    
    // MARK: - Private Helpers
    private func createImageFolder() {
        let imageFolder = getImageFolder()
        var isDirectory = ObjCBool(true)
        if !FileManager.default.fileExists(atPath: imageFolder.path, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: imageFolder.path, withIntermediateDirectories: true)
        }
    }
    
    /// Pulls the first request object on the queue and downloads an image then calls the success or failure if provided. If the queue isn't empty will recursively call fetch image
    private func fetchImages() {
        let imageRequestObject = requestQueue.removeFirst()
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
    
    private func getFileLocally(_ url: String) -> Data? {
        getFile(at: getFileURL(url))
    }
    
    private func getFileURL(_ url: String) -> URL {
        getImageFolder().appendingPathComponent(URL(string: url)?.lastPathComponent ?? "")
    }
    
    private func getFile(at fileURL: URL) -> Data? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return data
    }
    
    private func getImageFolder() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(localImageFolder).absoluteURL ?? URL(fileURLWithPath: "")
    }
}
