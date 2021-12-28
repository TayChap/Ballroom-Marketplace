//
//  BuyVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class BuyVC: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var sellButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    // MARK: - Lifecycle Methods
    
    // MARK: - IBActions
    @IBAction func sellButtonClicked() {
        
    }
    
    @IBAction func profileButtonClicked() {
        guard let _ = AuthenticationManager().user else {
            presentViewController(LoginVC.createViewController())
            return
        }
        
        
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
    
    // MARK: - Private Helpers
}
