//
//  AuthenticationManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import Firebase

struct AuthenticationManager {
    struct User {
        let email: String
        let displayName: String
        // TODO! add optional profile image
    }
    
    var user: User? {
        guard
            let user = Auth.auth().currentUser,
            let email = user.email,
            let displayName = user.displayName
        else {
            return nil
        }
        
        return User(email: email, displayName: displayName)
    }
    
    func createUser(email: String, password: String, displayName: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges { error in
                completion()
            }
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
}
