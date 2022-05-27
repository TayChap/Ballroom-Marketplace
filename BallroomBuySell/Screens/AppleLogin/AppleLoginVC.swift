//
//  AppleLoginVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-05-25.
//

import AuthenticationServices
import UIKit

class AppleLoginVC: UIViewController, ViewControllerProtocol, AuthenticatorProtocol {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var appleButton: UIButton!
    
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        if Environment.current != .production {
            return NavigationController(rootViewController: LoginVC.createViewController()) // login for QA instead
        }
        
        let vc = AppleLoginVC(nibName: String(describing: AppleLoginVC.self), bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
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
        signIn()
    }
    
    // MARK: - ViewControllerProtocol
    func dismiss() {
        dismiss(animated: false)
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
        picker.dismiss(animated: true, completion: nil)
        profilePictureSelected(info: info)
    }
}
