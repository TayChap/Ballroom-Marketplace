//
//  DatabaseManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Firebase
import FirebaseFirestoreSwift

struct DatabaseManager {
    enum Collection: String, CaseIterable {
        case templates, items, threads
        
        var collectionId: String {
            "\(Environment.current.rawValue)-\(self.rawValue)"
        }
    }
    
    static let sharedInstance = DatabaseManager()
    private var db = Firestore.firestore()
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func createDocument<T: Codable>(_ collection: Collection, _ data: T, _ documentId: String? = nil) {
        do {
            guard let documentId = documentId else {
                try db.collection(collection.collectionId).document().setData(from: data)
                return
            }
            
            try db.collection(collection.collectionId).document(documentId).setData(from: data)
          }
          catch {
            print(error)
          }
    }
    
    func getTemplates(_ completion: @escaping ([SaleItemTemplate]) -> Void) {
        getDocuments(db.collection(Collection.templates.collectionId), of: SaleItemTemplate.self, completion)
    }
    
    func getRecentSaleItems(for maxItems: Int, _ completion: @escaping ([SaleItem]) -> Void) {
        let reference = db.collection(Collection.items.collectionId)
        getDocuments(reference.order(by: SaleItem.QueryKeys.dateAdded.rawValue, descending: true).limit(to: maxItems), of: SaleItem.self, completion)
        
    }
    
    func getSaleItems(where equalsRelationship: (key: String, value: String)? = nil, _ completion: @escaping ([SaleItem]) -> Void) { // TODO! refactor tuple weirdness
        var reference = db.collection(Collection.items.collectionId) as Query
        if let keyValue = equalsRelationship {
            reference = reference.whereField(keyValue.key, isEqualTo: keyValue.value)
        }
        
        getDocuments(reference, of: SaleItem.self, completion)
    }
    
    func getThreads(for userId: String, _ completion: @escaping ([MessageThread]) -> Void) {
        let query = db.collection(Collection.threads.collectionId).whereField(MessageThread.QueryKeys.userIds.rawValue, arrayContains: userId)
        getDocuments(query, of: MessageThread.self) { threads in
            completion(threads)
        }
    }
    
    func deleteSaleItem(with id: String, _ completion: @escaping () -> Void) {
        deleteDocument(in: .items, with: id) {
            // delete all threads associated with that sale item
            db.collection(Collection.threads.collectionId).whereField(MessageThread.QueryKeys.saleItemId.rawValue, in: [id]).getDocuments { querySnapshot, error in
                guard let doc = querySnapshot?.documents.first else {
                    return
                }
                
                db.collection(Collection.threads.collectionId).document(doc.documentID).delete()
                completion()
            }
        }
    }
    
    func deleteDocument(in collection: Collection, with id: String, _ completion: @escaping () -> Void) {
        db.collection(collection.collectionId).whereField("id", in: [id]).getDocuments { querySnapshot, error in // TODO!
            guard let doc = querySnapshot?.documents.first else {
                return
            }
            
            db.collection(collection.collectionId).document(doc.documentID).delete()
            completion()
        }
    }
    
    // Utility method for staging / debugging only
    func stagingDeleteAllDocuments(in collection: Collection, _ completion: @escaping () -> Void) {
        if Environment.current == .production {
            return // Firebase does not recommend deleting entire collections from mobile clients
        }

        db.collection(collection.collectionId).getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents else {
                return
            }

            for doc in docs {
                db.collection(collection.collectionId).document(doc.documentID).delete()
            }

            completion()
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
}
