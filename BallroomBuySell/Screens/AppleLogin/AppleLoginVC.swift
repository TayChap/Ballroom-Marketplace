//
//  AppleLoginVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-05-25.
//

import AuthenticationServices
import CryptoKit
import UIKit
import PhotosUI

class AppleLoginVC: UIViewController, ViewControllerProtocol, ASAuthorizationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var appleButton: UIButton!
    
    private var onLoginComplete: @MainActor () async -> Void = {}
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ onLoginComplete: @MainActor @escaping () async -> Void) -> UIViewController {
        if Environment.current != .production {
            return NavigationController(rootViewController: LoginVC.createViewController()) // login for QA instead
        }
        
        let vc = AppleLoginVC(nibName: String(describing: AppleLoginVC.self), bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.onLoginComplete = onLoginComplete
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = LocalizedString.string("login.terms.title")
        termsTextView.text = LocalizedString.string("login.terms.message")
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        dismiss()
    }
    
    @IBAction func appleButtonClicked() {
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
    
    // MARK: - ViewControllerProtocol
    func dismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        authorizationController(controller: controller, authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationController(controller: controller, error: error)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        let normalizedImage = selectedImage
        let resizedImage = normalizedImage.resize(newWidth: PhotoPicker.userAddedImageWidth)
        let image = Image(for: .user, data: resizedImage.pngData())
        Image.uploadImages([image])
        AuthenticationManager.sharedInstance.setUserImage(url: image.url)
        
        loginComplete()
    }
    
    // MARK: - PHPickerViewController Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        Task {
            let imageData = await PhotoPicker.getImagesResults(results).first
            let image = Image(for: .user, data: imageData)
            Image.uploadImages([image])
            AuthenticationManager.sharedInstance.setUserImage(url: image.url)
            loginComplete()
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
            self.showNetworkError(NetworkError.internalSystemError)
            return
        }
        
        Task {
            do {
                let name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
                try await AuthenticationManager.sharedInstance.appleSignIn(name, appleIDCredential.email, idTokenString, nonce)
                if AuthenticationManager.sharedInstance.user?.photoURL != nil {
                    self.loginComplete()
                    return
                }
                
                let now = UIAlertAction(title: LocalizedString.string("generic.now"), style: .default) { _ in
                    self.displayMediaActionSheet()
                }
                
                let later = UIAlertAction(title: LocalizedString.string("generic.later"), style: .cancel) { _ in
                    self.loginComplete()
                }
                
                self.showAlertWith(message: LocalizedString.string("login.add.picture.message"), alertActions: [now, later])
            } catch {
                showNetworkError(error)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, error: Error) {
        // user hit cancel - take no action
    }
    
    // MARK: - Private Helpers
    private func loginComplete() {
        dismiss(animated: true) {
            Task {
                await self.onLoginComplete()
            }
        }
    }
    
    /// Display photo selection options to the user
    private func displayMediaActionSheet() {
        var actionItems = [UIAlertAction]()
        actionItems.append(UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel))
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.camera.app"), style: .default) { _ in
            Camera.displayCamera(self, displayingVC: self)
        })
        
        actionItems.append(UIAlertAction(title: LocalizedString.string("apple.photos.app"), style: .default) { _ in
            let picker = PHPickerViewController(configuration: PhotoPicker.getConfiguration(with: 1))
            picker.delegate = self
            self.present(picker, animated: true)
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
