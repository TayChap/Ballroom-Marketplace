//
//  ImageManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import FirebaseStorage

struct FileSystemManager {
    private static var storage: Storage {
        Storage.storage()
    }
    
    // MARK: - Public Helpers
    static func putFile(_ data: Data, at url: String) {
        storage.reference().child(url).putData(data)
    }
    
    static func getFile(at url: String, _ completion: @escaping (_ data: Data) -> Void) {
        // check for file locally
        if let data = getFile(at: getFileURL(url)) {
            completion(data)
            return
        }
        
        // download from the server
        let fileURL = getFileURL(url)
        storage.reference().child(url).write(toFile: fileURL) { _ , error in
            guard let data = self.getFile(at: fileURL), error == nil else {
                return // TODO! error
            }
            
            completion(data)
        }
    }
    
    private static func getFileURL(_ url: String) -> URL {
        let fileFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: "")
        return fileFolder.appendingPathComponent(URL(string: url)?.lastPathComponent ?? "")
    }
    
    private static func getFile(at fileURL: URL) -> Data? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return data
    }
}
