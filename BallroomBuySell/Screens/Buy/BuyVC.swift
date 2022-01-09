//
//  BuyVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class BuyVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol {
    @IBOutlet weak var sellButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: BuyVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = BuyVM(self)
        
        vm.viewDidLoad(tableView)
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
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.tableView(tableView, didSelectRowAt: indexPath, self)
        //        tableView.reloadData() // TODO! evaluate
        //        checkRequiredFields()
        // TODO!
    }
    
    // MARK: - Private Helpers
}
