//
//  InboxVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var vm: InboxVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController( _ user: User, _ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = InboxVM(owner: vc,
                        user: user,
                        templates: templates)
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signOutButton.title = LocalizedString.string("generic.logout")
        vm.viewWillAppear(onFetch)
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        vm.tableView(tableView, commit: editingStyle, forRowAt: indexPath, completion: onFetch)
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
    
    // MARK: - Private Helpers
    /// On fetching items, call down to the VM to update the data and then reload the screen
    /// - Parameters:
    ///   - saleItems: the saleItems fetched
    ///   - threads: the threads fetched
    private func onFetch(_ saleItems: [SaleItem], _ threads: [MessageThread]) {
        vm.onFetch(saleItems, threads)
        reload()
    }
}
