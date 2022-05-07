//
//  AuthenticationManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import Firebase

struct AuthenticationManager {
    static var currentNonce: String?
    
    var user: User? {
        guard
            let user = Auth.auth().currentUser,
            let displayName = user.displayName
        else {
            return nil
        }
        
        return User(id: user.uid, email: user.email, photoURL: user.photoURL?.absoluteString, displayName: displayName)
    }
    
    // MARK: - Production only authentication
    func appleSignIn(_ displayName: String, _ email: String?, _ idTokenString: String, _ nonce: String, _ completion: @escaping (User) -> Void, onFail: @escaping () -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { result, error in
            guard let user = result?.user, error == nil else {
                onFail() // TODO! apple sign in error
                return
            }
            
            DatabaseManager.sharedInstance.getUser(with: user.uid) { codableUser in
                completion(codableUser)
            } onFail: {
                // user does not exist, so add to database
                let codableUser = User(id: user.uid,
                                       email: email,
                                       photoURL: nil,
                                       displayName: displayName)
                DatabaseManager.sharedInstance.putDocument(in: .users, for: codableUser, with: user.uid, {
                    completion(codableUser)
                }, onFail: onFail)
            }
        }
    }
    
    // MARK: - Staging only authentication
    func createStagingUser(email: String, password: String = "Tester", displayName: String, photo: Image, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let userId = result?.user.uid else {
                return // staging so no error message required
            }
            
            Image.uploadImages([photo])
            let codableUser = User(id: userId,
                                   email: email,
                                   photoURL: photo.url,
                                   displayName: displayName)
            DatabaseManager.sharedInstance.putDocument(in: .users, for: codableUser, with: userId) {
                completion() // TODO! fetch user and update singleton
            } onFail: {
                // staging so no error message required
            }
        }
    }
    
    func loginStagingUser(email: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: "Tester") { result, error in
            if let _ = error {
                return // staging so no error message required
            }
            
            // TODO! fetch user and update singleton
            
            completion()
        }
    }
    
    func signOut(onSuccess: () -> Void, onFail: () -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch {
            onFail()
        }
    }
}
