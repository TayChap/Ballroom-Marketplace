//
//  AuthenticatorProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-11.
//

import AuthenticationServices
import CryptoKit

protocol AuthenticatorProtocol: ViewControllerProtocol, ASAuthorizationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func signIn()
}

extension AuthenticatorProtocol {
    func signIn() {
        switch Environment.current {
        case .production:
            startSignInWithAppleFlow()
        case .staging, .marketing:
            presentViewController(LoginVC.createViewController())
        }
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = AuthenticationManager.currentNonce,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            self.showNetworkError()
            return
        }
        
        AuthenticationManager().appleSignIn(idTokenString, nonce) {
            if AuthenticationManager().user != nil {
                self.showAlertWith(message: LocalizedString.string("generic.success"))
                return
            }
            
            let name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            AuthenticationManager().changeRequest(displayName: name) {
                // Display alert to optionally add profile photo
                let now = UIAlertAction(title: LocalizedString.string("generic.now"), style: .default) { _ in
                    self.displayMediaActionSheet()
                }
                
                let later = UIAlertAction(title: LocalizedString.string("generic.later"), style: .cancel)
                self.showAlertWith(message: LocalizedString.string("login.add.picture.message"),
                                   alertActions: [now, later])
            } onFail: {
                self.showNetworkError()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, error: Error) {
        showNetworkError()
    }
    
    func profilePictureSelected(info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImageData = (info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage)?.pngData() else {
            return
        }
        
        let image = Image(data: selectedImageData)
        Image.uploadImages([image])
        AuthenticationManager().changeRequest(photoURL: image.url) {
            self.showAlertWith(message: LocalizedString.string("generic.success"))
        } onFail: {
            self.showNetworkError()
        }
    }
    
    // MARK: - Private Helpers
    /// Log in an existing production user or, if they have not registered yet, register using their available Apple information
    private func startSignInWithAppleFlow() {
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
    
    /// Display photo selection options to the user
    private func displayMediaActionSheet() {
        var actionItems = [UIAlertAction]()
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.camera.app"), style: .default) { _ in
            MediaManager.displayCamera(self, displayingVC: self)
        })
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.photos.app"), style: .default) { _ in
            MediaManager.displayGallery(self, displayingVC: self)
        })
        
        showActionSheetOrPopover(message: LocalizedString.string("sale.item.images.actions"), alertActions: actionItems)
    }
    
    /// Firebase recommended method; do not alter
    private func randomNonceString(length: Int = 32) -> String {
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
    
    /// Firebase recommended method; do not alter
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
