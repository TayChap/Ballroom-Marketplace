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
        case templates, items, threads
    }
    
    static let sharedInstance = DatabaseManager()
    private var db = Firestore.firestore()
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
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
    
    func getTemplates(_ completion: @escaping ([SaleItemTemplate]) -> Void) {
        getDocuments(db.collection(Collection.templates.rawValue), of: SaleItemTemplate.self, completion)
    }
    
    func getRecentSaleItems(for maxItems: Int, _ completion: @escaping ([SaleItem]) -> Void) {
        let reference = db.collection(Collection.items.rawValue)
        getDocuments(reference.order(by: SaleItem.QueryKeys.dateAdded.rawValue, descending: true).limit(to: maxItems), of: SaleItem.self, completion)
        
    }
    
    func getSaleItems(where equalsRelationship: (key: String, value: String)? = nil, _ completion: @escaping ([SaleItem]) -> Void) { // TODO! refactor tuple weirdness
        var reference = db.collection(Collection.items.rawValue) as Query
        if let keyValue = equalsRelationship {
            reference = reference.whereField(keyValue.key, isEqualTo: keyValue.value)
        }
        
        getDocuments(reference, of: SaleItem.self, completion)
    }
    
    func getThreads(for userId: String, _ completion: @escaping ([MessageThread]) -> Void) {
        let query = db.collection(Collection.threads.rawValue).whereField(MessageThread.QueryKeys.userIds.rawValue, arrayContains: userId)
        getDocuments(query, of: MessageThread.self) { threads in
            completion(threads)
        }
    }
    
    // MARK: Private Helpers
    private func getDocuments<T: Decodable>(_ query: Query, of _: T.Type, where equalsRelationship: (key: String, value: String)? = nil, _ completion: @escaping ([T]) -> Void) {
        query.getDocuments { querySnapshot, error  in
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
