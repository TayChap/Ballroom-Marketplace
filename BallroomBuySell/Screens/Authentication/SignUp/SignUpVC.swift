//
//  SignUpVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class SignUpVC: UIViewController, ViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var vm: SignUpVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        guard let vc = StoryboardManager().getAuthentication().instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as? SignUpVC else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        vc.vm = SignUpVM(vc)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(tableView)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    // MARK: - ViewControllerProtocol
    func dismiss() {
//        AuthenticationManager().createUser(email: "hi2@gmail.com", password: "test123", displayName: "cool test name") {
//            self.dismiss()
//        }
        
        dismiss(animated: true)
    }
}
