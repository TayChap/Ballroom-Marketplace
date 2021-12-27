//
//  SignUpVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class SignUpVC: UIViewController, ViewControllerProtocol {
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        guard let vc = StoryboardManager().getAuthentication().instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as? SignUpVC else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        return vc
    }
    
    // MARK: - IBActions
    @IBAction func testDismiss(_ sender: Any) {
        dismiss()
    }
    
    // MARK: - ViewControllerProtocol
    func dismiss() {
        dismiss(animated: true)
    }
}
