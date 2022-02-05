//
//  AuthenticationManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import Firebase

struct AuthenticationManager {    
    var user: User? {
        guard
            let user = Auth.auth().currentUser,
            let photoURL = user.photoURL,
            let displayName = user.displayName
        else {
            return nil
        }
        
        return User(id: user.uid, photoURL: photoURL.absoluteString, displayName: displayName)
    }
    
    func createUser(email: String, password: String, displayName: String, photo: Image, completion: @escaping () -> Void, onFail: @escaping (_ errorMessage: String) -> Void) {
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
    
    func login(email: String, password: String, completion: @escaping () -> Void, onFail: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                onFail(getErrorMessage(error))
                return
            }
            
            completion()
        }
    }
    
    // TODO! Sign out button calls on profile tab
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
