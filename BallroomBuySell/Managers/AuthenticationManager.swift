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
    }
    
    var user: User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return User(email: user.email ?? "")
    }
    
    func createUser(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
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
}
