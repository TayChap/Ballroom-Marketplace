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
                                  for data: T) throws {
        if !Reachability.isConnectedToNetwork {
            throw NetworkError.notConnected
        }
        
        do {
            try db.collection(collection.collectionId).document(data.id).setData(from: data)
        }
        catch {
            throw NetworkError.accessFailure
        }
    }
    
    func getDocument<T: Decodable>(in collection: FirebaseCollection,
                                   of _: T.Type,
                                   with id: String) async throws -> T {
        let items = try await getDocuments(to: collection,
                                           of: T.self,
                                           whereFieldEquals: (key: "id", value: id))
        
        guard let item = items.first else {
            throw NetworkError.notFound
        }
        
        return item
    }
    
    func getDocuments<T: Decodable>(to collection: FirebaseCollection,
                                    of _: T.Type,
                                    whereFieldEquals equalsRelationship: (key: String, value: String)? = nil,
                                    whereArrayContains containsRelationship: (key: String, value: String)? = nil,
                                    withOrderRule orderRule: (field: String, descending: Bool, limit: Int)? = nil) async throws -> [T] {
        if !Reachability.isConnectedToNetwork {
            throw NetworkError.notConnected
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
        
        let docs = try await reference.getDocuments().documents
        return try docs.compactMap({ doc in
            return try doc.data(as: T.self)
        }).filter({ ($0 as? Reportable)?.isAcceptable() ?? true })
    }
    
    func deleteDocuments(in collection: FirebaseCollection,
                        where field: String,
                        equals value: String) async throws {
        let documents = try await db.collection(collection.collectionId).whereField(field, isEqualTo: value).getDocuments().documents
        for doc in documents {
            try await db.collection(collection.collectionId).document(doc.documentID).delete()
        }
    }
}
