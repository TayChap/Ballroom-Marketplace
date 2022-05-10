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
        case templates, users, items, threads, reports
        
        var collectionId: String {
            "\(Environment.current.rawValue)-\(self.rawValue)"
        }
    }
    
    static let sharedInstance = DatabaseManager()
    private var db = Firestore.firestore()
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Public Helpers
    func putDocument<T: Codable>(in collection: Collection, for data: T, with documentId: String? = nil, _ completion: () -> Void, onFail: () -> Void) {
        if !Reachability.isConnectedToNetwork {
            onFail()
            return
        }
        
        do {
            guard let documentId = documentId else {
                try db.collection(collection.collectionId).document().setData(from: data)
                completion()
                return
            }
            
            try db.collection(collection.collectionId).document(documentId).setData(from: data)
            completion()
          }
          catch {
            onFail()
          }
    }
    
    func getUser(with id: String, _ completion: @escaping (User) -> Void, onFail: @escaping () -> Void) {
        getDocuments(getReference(to: .users, with: (key: "id", value: id)), of: User.self, { users in
            guard let user = users.first else {
                onFail()
                return
            }
            
            completion(user)
        }, onFail)
    }
    
    func getTemplates(_ completion: @escaping ([SaleItemTemplate]) -> Void, _ onFail: @escaping () -> Void) {
        getDocuments(db.collection(Collection.templates.collectionId), of: SaleItemTemplate.self, completion, onFail)
    }
    
    func getRecentSaleItems(for maxItems: Int, _ completion: @escaping ([SaleItem]) -> Void, _ onFail: @escaping () -> Void) {
        let reference = db.collection(Collection.items.collectionId)
        getDocuments(reference.order(by: SaleItem.QueryKeys.dateAdded.rawValue, descending: true).limit(to: maxItems), of: SaleItem.self, completion, onFail)
        
    }
    
    func getSaleItems(where equalsRelationship: (key: String, value: String)? = nil, _ completion: @escaping ([SaleItem]) -> Void, _ onFail: @escaping () -> Void) {
        getDocuments(getReference(to: .items, with: equalsRelationship), of: SaleItem.self, completion, onFail)
    }
    
    func getThreads(for userId: String, _ completion: @escaping ([MessageThread]) -> Void, _ onFail: @escaping () -> Void) {
        let query = db.collection(Collection.threads.collectionId).whereField(MessageThread.QueryKeys.userIds.rawValue, arrayContains: userId)
        getDocuments(query, of: MessageThread.self, { threads in
            completion(threads)
        }, {
            onFail()
        })
    }
    
    func deleteSaleItem(with id: String, _ completion: @escaping () -> Void, _ onFail: @escaping () -> Void) {
        deleteDocument(in: .items, with: id, {
            // delete all threads associated with that sale item
            db.collection(Collection.threads.collectionId).whereField(MessageThread.QueryKeys.saleItemId.rawValue, in: [id]).getDocuments { querySnapshot, error in
                guard let docs = querySnapshot?.documents, error == nil else {
                    onFail()
                    return
                }
                
                for doc in docs {
                    db.collection(Collection.threads.collectionId).document(doc.documentID).delete()
                }
                
                completion()
            }
        }, onFail)
    }
    
    func deleteDocument(in collection: Collection, with id: String, _ completion: @escaping () -> Void, _ onFail: @escaping () -> Void) {
        db.collection(collection.collectionId).whereField("id", in: [id]).getDocuments { querySnapshot, error in
            guard let doc = querySnapshot?.documents.first, error == nil else {
                onFail()
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
                return // staging so no error message required
            }
            
            for doc in docs {
                db.collection(collection.collectionId).document(doc.documentID).delete()
            }
            
            completion()
        }
    }
    
    // MARK: Private Helpers
    private func getDocuments<T: Decodable>(_ query: Query, of _: T.Type, where equalsRelationship: (key: String, value: String)? = nil, _ completion: @escaping ([T]) -> Void, _ onFail: @escaping () -> Void) {
        if !Reachability.isConnectedToNetwork {
            onFail()
            return
        }
        
        query.getDocuments { querySnapshot, error  in
            guard let docs = querySnapshot?.documents, error == nil else {
                onFail()
                return
            }
            
            do {
                return completion(try docs.compactMap({ doc in
                        return try doc.data(as: T.self)
                }).filter({ ($0 as? Reportable)?.isAcceptable() ?? true }))
            } catch {
                return
            }
        }
    }
    
    private func getReference(to collection: Collection, with equalsRelationship: (key: String, value: String)? = nil) -> Query {
        var reference = db.collection(collection.collectionId) as Query
        if let keyValue = equalsRelationship {
            reference = reference.whereField(keyValue.key, isEqualTo: keyValue.value)
        }
        
        return reference
    }
}
