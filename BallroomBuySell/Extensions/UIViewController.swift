//
//  UIViewController.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-20.
//

import AuthenticationServices
import CryptoKit

extension UIViewController: ASAuthorizationControllerDelegate {
    // MARK: - IB Methods
    static func getVC<T>(from storyboard: Storyboard, of type: T.Type) -> T {
        UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    // MARK: - Alert Methods
    func showAlertWith(title: String? = "", message: String, alertActions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertActions = alertActions {
            for action in alertActions {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: NSLocalizedString("generic.close", comment: "Closes alert"), style: .default, handler: nil))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheetOrPopover(_ title: String?, _ message: String, _ alertActions: [UIAlertAction], _ barButtonItem: UIBarButtonItem? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in alertActions {
            alert.addAction(action)
        }
        
        if let barButtonItem = barButtonItem {
            alert.popoverPresentationController?.barButtonItem = barButtonItem
        } else {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Authentication Methods
    func signIn() {
        switch Environment.current {
        case .production:
            startSignInWithAppleFlow()
        case .staging:
            present(NavigationController(rootViewController: LoginVC.createViewController()), animated: true)
        }
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = AuthenticationManager.currentNonce,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            // TODO! handle error
            return
        }
        
        // TODO! present photo request - Now, Later options
        
        AuthenticationManager().appleSignIn(idTokenString, nonce)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // TODO! Handle error
      print("Sign in with Apple errored: \(error)")
    }
    
    // MARK: - Private Helpers
    private func startSignInWithAppleFlow() { // TODO! refactor
        let nonce = randomNonceString()
        AuthenticationManager.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String { // Firebase recommended method; do not alter
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String { // Firebase recommended method; do not alter
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
