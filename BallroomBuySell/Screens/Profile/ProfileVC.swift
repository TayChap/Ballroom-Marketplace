//
//  ProfileVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class ProfileVC: UIViewController, ViewControllerProtocol {
    // MARK: - Lifecycle Methods
    static func createViewController(_ user: User) -> UIViewController {
        guard let vc = StoryboardManager().getMain().instantiateViewController(withIdentifier: String(describing: ProfileVC.self)) as? ProfileVC else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        // TODO! user
        return vc
    }
}
