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
    func createDocument<T: Codable>(_ collectionId: String, _ documentId: String?, _ data: T) {
        do {
            guard let documentId = documentId else {
                try db.collection(collectionId).document().setData(from: data)
                return
            }
            
            try db.collection(collectionId).document(documentId).setData(from: data)
          }
          catch {
            print(error)
          }
    }
    
    func getTemplates(_ completion: @escaping ([SaleItemTemplate]) -> Void) {
        db.collection("templates").getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents else {
                return
            }
            
            return completion(docs.compactMap({ doc in
                do {
                    return try doc.data(as: SaleItemTemplate.self)
                } catch {
                    return nil
                }
            }))
        }
    }
}
