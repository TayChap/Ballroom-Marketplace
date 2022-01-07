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
    private var vm: BuyVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = BuyVM(self)
        
        //vm.viewDidLoad(tableView)
    }
    
    // MARK: - IBActions
    @IBAction func sellButtonClicked() {
        vm.sellButtonClicked()
    }
    
    @IBAction func profileButtonClicked() {
        vm.profileButtonClicked()
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
