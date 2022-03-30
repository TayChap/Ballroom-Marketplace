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
        
        return User(id: user.uid, photoURL: user.photoURL?.absoluteString, displayName: displayName)
    }
    
    // MARK: - Production only authentication
    func appleSignIn(_ idTokenString: String, _ nonce: String, _ completion: @escaping () -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { _ , _ in
            completion()
        }
    }
    
    func changeRequest(displayName: String? = nil, photoURL: String? = nil, completion: @escaping () -> Void, onFail: @escaping () -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        if let displayName = displayName {
            changeRequest?.displayName = displayName
        }
        
        if let photoURL = photoURL {
            changeRequest?.photoURL = URL(string: photoURL)
        }
        
        changeRequest?.commitChanges { error in
            if let _ = error {
                onFail()
                return
            }
            
            completion()
        }
    }
    
    // MARK: - Staging only authentication
    func createStagingUser(email: String, password: String = "Tester", displayName: String, photo: Image, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _ = error {
                return // staging so no error message required
            }
            
            Image.uploadImages([photo])
            changeRequest(displayName: displayName,
                          photoURL: photo.url,
                          completion: completion,
                          onFail: {}) // staging so no error message required
        }
    }
    
    func loginStagingUser(email: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: "Tester") { authResult, error in
            if let _ = error {
                return // staging so no error message required
            }
            
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
