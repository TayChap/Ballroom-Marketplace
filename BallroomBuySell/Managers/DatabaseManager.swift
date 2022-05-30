//
//  DatabaseManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Firebase
import FirebaseFirestoreSwift

struct DatabaseManager {
    enum FirebaseCollection: String, CaseIterable {
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
    func putDocument<T: Storable>(in collection: FirebaseCollection,
                                  for data: T,
                                  _ completion: () -> Void,
                                  onFail: () -> Void) {
        if !Reachability.isConnectedToNetwork {
            onFail()
            return
        }
        
        do {
            try db.collection(collection.collectionId).document(data.id).setData(from: data)
            completion()
          }
          catch {
            onFail()
          }
    }
    
    func getDocument<T: Decodable>(in collection: FirebaseCollection,
                                   of _: T.Type,
                                   with id: String,
                                   _ completion: @escaping (T) -> Void,
                                   onFail: @escaping () -> Void) {
        getDocuments(to: collection,
                     of: T.self,
                     whereFieldEquals: (key: "id", value: id), { items in
            guard let item = items.first else {
                onFail()
                return
            }
            
            completion(item)
        }, onFail: onFail)
    }
    
    func getDocuments<T: Decodable>(to collection: FirebaseCollection,
                                    of _: T.Type,
                                    whereFieldEquals equalsRelationship: (key: String, value: String)? = nil,
                                    whereArrayContains containsRelationship: (key: String, value: String)? = nil,
                                    withOrderRule orderRule: (field: String, descending: Bool, limit: Int)? = nil,
                                    _ completion: @escaping ([T]) -> Void,
                                    onFail: @escaping () -> Void) {
        if !Reachability.isConnectedToNetwork {
            onFail()
            return
        }
        
        // create the query
        var reference = db.collection(collection.collectionId) as Query
        
        if let equalsRelationship = equalsRelationship {
            reference = reference.whereField(equalsRelationship.key, isEqualTo: equalsRelationship.value)
        }
        
        if let containsRelationship = containsRelationship {
            reference = reference.whereField(containsRelationship.key, arrayContains: containsRelationship.value)
        }
        
        if let orderRule = orderRule {
            reference = reference.order(by: orderRule.field, descending: orderRule.descending).limit(to: orderRule.limit)
        }
        
        // fetch from the DB based on the query
        reference.getDocuments { querySnapshot, error  in
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
    
    // TODO! just try to move this method out into InboxVM
    func deleteSaleItem(with id: String,
                        _ completion: @escaping () -> Void,
                        _ onFail: @escaping () -> Void) {
        deleteDocument(in: .items, with: id, {
            // TODO! delete all images associated with that sale item
            
            // delete all threads associated with that sale item
            db.collection(FirebaseCollection.threads.collectionId).whereField(MessageThread.QueryKeys.saleItemId.rawValue, in: [id]).getDocuments { querySnapshot, error in
                guard let docs = querySnapshot?.documents, error == nil else {
                    onFail()
                    return
                }
                
                for doc in docs {
                    db.collection(FirebaseCollection.threads.collectionId).document(doc.documentID).delete()
                }
                
                completion()
            }
        }, onFail)
    }
    
    func deleteDocument(in collection: FirebaseCollection,
                        with id: String,
                        _ completion: @escaping () -> Void,
                        _ onFail: @escaping () -> Void) {
        db.collection(collection.collectionId).whereField("id", in: [id]).getDocuments { querySnapshot, error in
            guard let doc = querySnapshot?.documents.first, error == nil else {
                onFail()
                return
            }
            
            db.collection(collection.collectionId).document(doc.documentID).delete()
            completion()
        }
    }
}
