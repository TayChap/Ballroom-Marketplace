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
        
        guard let user = AuthenticationManager().user else {
            presentViewController(LoginVC.createViewController())
            return
        }
        
        // TODO! initialize table
    }
    
    // MARK: - ViewControllerProtocol
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
}
