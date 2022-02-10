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
    func appleSignIn(_ idTokenString: String, _ nonce: String, _ profileImage: String? = nil) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(getErrorMessage(error)) // TODO! evaluate error
                return
            }
        }
        
        // TODO! present sign in successful message or push next screen
    }
    
    // MARK: - Staging only authentication
    func createStagingUser(email: String, password: String, displayName: String, photo: Image, completion: @escaping () -> Void, onFail: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                onFail(getErrorMessage(error))
                return
            }
            
            // update user profile photo
            Image.uploadImages([photo])

            // update displayName after user created
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.photoURL = URL(string: photo.url)
            changeRequest?.commitChanges { error in
                if let error = error {
                    onFail(getErrorMessage(error))
                    return
                }

                completion()
            }
        }
    }
    
    func loginStagingUser(email: String, completion: @escaping () -> Void, onFail: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: "Tester") { authResult, error in
            if let error = error {
                onFail(getErrorMessage(error))
                return
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
    
    // MARK: - Private Helpers
    private func getErrorMessage(_ error: Error) -> String {
        error.localizedDescription // TODO! user facing errors
    }
}
