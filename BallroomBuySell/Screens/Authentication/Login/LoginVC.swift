//
//  LoginVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class LoginVC: UIViewController, ViewControllerProtocol {
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        guard let vc = StoryboardManager().getAuthentication().instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as? LoginVC else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        return vc
    }
    
    @IBAction func testPush(_ sender: Any) {
        pushViewController(SignUpVC.createViewController())
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
