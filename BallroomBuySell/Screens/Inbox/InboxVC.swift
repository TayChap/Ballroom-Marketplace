//
//  InboxVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol {
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var vm: InboxVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController( _ user: User, _ threads: [MessageThread], _ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = InboxVM(vc, user, threads, templates)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad { saleItems in
            self.vm.onItemsFetched(saleItems)
            self.reload()
        }
    }
    
    // MARK: - IBActions
    @IBAction func signOutButtonClicked() {
        vm.signOutButtonClicked()
    }
    
    @IBAction func segmentedControlClicked() {
        vm.segmentedControlClicked(segmentedControl.selectedSegmentIndex)
        reload()
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
}
