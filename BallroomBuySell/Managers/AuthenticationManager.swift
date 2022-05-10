//
//  AuthenticationManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import Firebase

class AuthenticationManager {
    static let sharedInstance = AuthenticationManager()
    
    private(set) var user: User?
    static var currentNonce: String?
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - Production only authentication
    func appleSignIn(_ displayName: String, _ email: String?, _ idTokenString: String, _ nonce: String, _ completion: @escaping () -> Void, onFail: @escaping () -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { result, error in
            guard let user = result?.user, error == nil else {
                onFail()
                return
            }
            
            DatabaseManager.sharedInstance.getUser(with: user.uid) { codableUser in
                self.user = codableUser
                completion()
            } onFail: {
                // user does not exist, so add to database
                let codableUser = User(id: user.uid,
                                       email: email,
                                       photoURL: nil,
                                       displayName: displayName)
                DatabaseManager.sharedInstance.putDocument(in: .users, for: codableUser, with: user.uid, {
                    self.user = codableUser
                    completion()
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
                self.user = codableUser
                completion()
            } onFail: {
                // staging so no error message required
            }
        }
    }
    
    func loginStagingUser(email: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: "Tester") { result, error in
            guard let userId = result?.user.uid else {
                return // staging so no error message required
            }
            
            DatabaseManager.sharedInstance.getUser(with: userId) { user in
                self.user = user
                completion()
            } onFail: {
                return // staging so no error message required
            }
        }
    }
    
    func signOut(onSuccess: () -> Void, onFail: () -> Void) {
        do {
            try Auth.auth().signOut()
            self.user = nil
            onSuccess()
        } catch {
            onFail()
        }
    }
    
    // MARK: - User Mutating Methods
    func setUserImage(url: String) {
        user?.photoURL = url
    }
    
    func blockUser(_ id: String) {
        self.user?.blockedUserIds.append(id)
    }
}
