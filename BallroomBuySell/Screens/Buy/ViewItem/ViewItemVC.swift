//
//  ViewItemVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-13.
//

import UIKit

class ViewItemVC: UIViewController, UITableViewDataSource, ViewControllerProtocol {
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemVM(vc, templates)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(tableView)
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
    }
    
    // MARK: - Private Helpers
}
