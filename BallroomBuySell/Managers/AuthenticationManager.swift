//
//  AuthenticationManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import Firebase

class AuthenticationManager {
    static let sharedInstance = AuthenticationManager()
    static var currentNonce: String?
    private(set) var user: User?
    
    // MARK: - Private Init
    private init() { } // to ensure sharedInstance is accessed, rather than new instance
    
    // MARK: - User Methods
    func signOut(onSuccess: () -> Void, onFail: () -> Void) {
        do {
            try Auth.auth().signOut()
            self.user = nil
            onSuccess()
        } catch {
            onFail()
        }
    }
    
    func refreshUser() {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        Task {
            do {
                let user = try await DatabaseManager.sharedInstance.getDocument(in: .users,
                                                                                of: User.self,
                                                                                with: id)
                self.user = user
            } catch NetworkError.notFound {
                user = nil
            } catch NetworkError.notConnected {
                // do nothing
            }
        }
    }
    
    func updateUser(_ user: User,
                    with photo: Image) throws {
        Image.uploadImages([photo])
        do {
            try DatabaseManager.sharedInstance.putDocument(in: .users,
                                                           for: user)
            self.user = user
        } catch {
            throw error
        }
    }
    
    func setUserImage(url: String) {
        user?.photoURL = url
    }
    
    func blockUser(_ id: String) {
        self.user?.blockedUserIds.append(id)
    }
    
    // MARK: - Production only authentication
    func appleSignIn(_ displayName: String, _ email: String?, _ idTokenString: String, _ nonce: String, _ completion: @escaping () -> Void, onFail: @escaping () -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Auth.auth().signIn(with: credential) { result, error in // TODO! async
            guard let user = result?.user, error == nil else {
                onFail()
                return
            }
            
            Task {
                do {
                    let codableUser = try await DatabaseManager.sharedInstance.getDocument(in: .users,
                                                                                           of: User.self,
                                                                                           with: user.uid)
                    self.user = codableUser
                    completion()
                } catch NetworkError.notFound {
                    // user does not exist, so add to database
                    let codableUser = User(id: user.uid,
                                           email: email,
                                           photoURL: nil,
                                           displayName: displayName)
                    try DatabaseManager.sharedInstance.putDocument(in: .users, for: codableUser)
                    self.user = codableUser
                    completion()
                } catch {
                    // TODO! throw error
                }
            }
        }
    }
    
    // MARK: - Staging only authentication
    func loginStagingUser(email: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: "Tester") { result, error in // TODO! mark as async
            guard let userId = result?.user.uid else {
                return // staging so no error message required
            }
            
            Task {
                do {
                    let user = try await DatabaseManager.sharedInstance.getDocument(in: .users,
                                                                                    of: User.self,
                                                                                    with: userId)
                    self.user = user
                    completion()
                } catch {
                    // TODO!
                }
            }
        }
    }
}
