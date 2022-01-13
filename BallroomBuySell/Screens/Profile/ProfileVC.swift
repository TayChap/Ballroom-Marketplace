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
        guard let vc = StoryboardManager().getVC(from: .main, of: self) else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        return vc
    }
}
