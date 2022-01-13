//
//  DatabaseManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Firebase
import FirebaseFirestoreSwift

struct DatabaseManager {
    private var db: Firestore {
        Firestore.firestore()
    }
    
    // MARK: - Public Helpers
    func createDocument<T: Codable>(_ collection: String, _ data: T, _ documentId: String? = nil) {
        do {
            guard let documentId = documentId else {
                try db.collection(collection).document().setData(from: data)
                return
            }
            
            try db.collection(collection).document(documentId).setData(from: data)
          }
          catch {
            print(error)
          }
    }
    
    func getDocuments<T: Decodable>(in collection: String, of _: T.Type, _ completion: @escaping ([T]?) -> Void) {
        db.collection(collection).getDocuments { querySnapshot, error  in
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
    func deleteDocuments(in collection: String, _ completion: @escaping () -> Void) {
        // TODO! add DEBUG flag here (not for release)
        
        db.collection(collection).getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents else {
                return
            }
            
            for doc in docs {
                db.collection(collection).document(doc.documentID).delete()
            }
            
            completion()
        }
    }
}
