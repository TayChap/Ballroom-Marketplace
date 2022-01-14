//
//  DatabaseManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Firebase
import FirebaseFirestoreSwift

struct DatabaseManager {
    enum Collection: String {
        case templates, items
    }
    
    private var db: Firestore {
        Firestore.firestore()
    }
    
    // MARK: - Public Helpers
    func createDocument<T: Codable>(_ collection: Collection, _ data: T, _ documentId: String? = nil) {
        do {
            guard let documentId = documentId else {
                try db.collection(collection.rawValue).document().setData(from: data)
                return
            }
            
            try db.collection(collection.rawValue).document(documentId).setData(from: data)
          }
          catch {
            print(error)
          }
    }
    
    func getDocuments<T: Decodable>(in collection: Collection, of _: T.Type, _ completion: @escaping ([T]?) -> Void) {
        db.collection(collection.rawValue).getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents else {
                return
            }
            
            return completion(docs.compactMap({ doc in
                do {
                    return try doc.data(as: T.self)
                } catch {
                    return nil
                }
            }))
        }
    }
    
    /// Firebase does not recommend deleting entire collections from mobile clients
    /// This method is used to delete templates only
    func deleteDocuments(in collection: Collection, _ completion: @escaping () -> Void) {
        // TODO! add DEBUG flag here (not for release)
        
        db.collection(collection.rawValue).getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents else {
                return
            }
            
            for doc in docs {
                db.collection(collection.rawValue).document(doc.documentID).delete()
            }
            
            completion()
        }
    }
}
