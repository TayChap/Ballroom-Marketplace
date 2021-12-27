//
//  ProfileVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class ProfileVC: UIViewController, ViewControllerProtocol {
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO! if not logged in
        presentViewController(LoginVC.createViewController())
    }
    
    // MARK: - ViewControllerProtocol
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
}
