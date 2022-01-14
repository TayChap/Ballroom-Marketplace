//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//  Adapted from Lawrence Tran
//

import FirebaseStorage

struct ImageRequestObject {
    var contentView: UIView?
    var url: String
    var success: (_ image: UIImage, _ fileName: String) -> Void
}

class ImageManager { // TODO! should be struct
    static let sharedInstance = ImageManager() // TODO! why? request queue can be the static component ?
    private var requestQueue = [ImageRequestObject]()
    
    private let imageFolderName = "images"
    private let maxQueueSize = 15
    private let maxSimultaneousCalls = 10
    private var currentCallCount = 0
    
    
    
    let testImageURL = "images/rivers.jpg"
    
    
    var storage: Storage {
        Storage.storage()
    }
    
    // MARK: - Public Helpers
    func uploadFile() {
        // Data in memory
        let data = Data()
        
        // Create a reference to the file you want to upload
        let riversRef = storage.reference().child(testImageURL)
        
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            // Metadata contains file metadata such as size, content-type.
            //let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let _ = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }
    
    func downloadFile(contentView: UIView? = nil, url: String, success: @escaping (_ image: UIImage, _ fileURL: String) -> Void) {
        createImageFolder()
        
        // Check if image has already been downloaded and returns if the image has been
        let fileName = URL(string: url)?.lastPathComponent ?? ""
        let imageFolder = getImageFolder()
        let fileURL = imageFolder.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                success(image, url)
            }
            
            return
        }
        
        // Removes first item if queue has exceeded size
        if requestQueue.count > maxQueueSize {
            let queueToRemove = requestQueue.removeLast()
            shouldAdd(activityIndicator: false, contentView: queueToRemove.contentView)
        }
        
        shouldAdd(activityIndicator: true, contentView: contentView)
        
        // Adds request into the queue and immediately fetches if current calls haven't exceeded allowed simutaneous calls
        requestQueue.insert(ImageRequestObject(contentView: contentView, url: url, success: success), at: 0)
        if currentCallCount < maxSimultaneousCalls {
            fetchImages()
        }
    }
    
    // MARK: - Private Helpers
    
    private func getImageFolder() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageFolderName).absoluteURL ?? URL(fileURLWithPath: "")
    }
    
    private func createImageFolder() {
        let imageFolder = getImageFolder()
        var isDirectory = ObjCBool(true)
        if !FileManager.default.fileExists(atPath: imageFolder.path, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: imageFolder.path, withIntermediateDirectories: true)
        }
    }
    
    /// Adds/Removes an activity indicator to/from the provided content view
    /// - Parameters:
    ///   - activityIndicator: Indicates if an activity indicator should be added or removed from the content view
    ///   - contentView: The content view to be actioned on
    private func shouldAdd(activityIndicator: Bool, contentView: UIView?) {
        guard let contentView = contentView else {
            return
        }
        
        if activityIndicator {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = CGPoint(x: contentView.frame.width / 2, y: contentView.frame.height / 2)
            indicator.startAnimating()
            contentView.addSubview(indicator)
        } else {
            contentView.subviews.filter({ $0 is UIActivityIndicatorView }).forEach({ $0.removeFromSuperview() })
        }
    }
    
    /// Pulls the first request object on the queue and downloads an image then calls the success or failure if provided. If the queue isn't empty will recursively call fetch image
    private func fetchImages() {
        let imageRequestObject = requestQueue.removeFirst()
        currentCallCount += 1
        
        let fileName = URL(string: imageRequestObject.url)?.lastPathComponent ?? ""
        let imageFolder = getImageFolder()
        let fileURL = imageFolder.appendingPathComponent(fileName)
        
        // Downloads image
        
        // Create a reference to the file you want to download
        let islandRef = storage.reference().child(testImageURL)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let _ = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            
            // Saves image and returns it
            try? data.write(to: fileURL)
            imageRequestObject.success(image, imageRequestObject.url)
            
            self.shouldAdd(activityIndicator: false, contentView: imageRequestObject.contentView)
            self.currentCallCount -= 1
            if self.requestQueue.count > 0 {
                self.fetchImages()
            }
          }
        }
    }
}
