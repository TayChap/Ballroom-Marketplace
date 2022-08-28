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
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var loadingSpinner: UIActivityIndicatorView?
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
        vm.refreshUser()
        loadingSpinner = addLoadingSpinner()
        
        Task {
            do {
                let items = try await vm.fetchItems()
                refreshItems(items.saleItems, items.threads)
            } catch {
                showNetworkError(error)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
    @IBAction func signOutButtonClicked() {
        vm.signOutButtonClicked()
    }
    
    @IBAction func profileButtonClicked() {
        Task {
            loadingSpinner?.startAnimating()
            profileButton.isEnabled = false
            await vm.profileButtonClicked()
            loadingSpinner?.stopAnimating()
            profileButton.isEnabled = true
        }
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
        Task {
            loadingSpinner?.startAnimating()
            tableView.isUserInteractionEnabled = false
            await vm.tableView(tableView, didSelectRowAt: indexPath)
            loadingSpinner?.stopAnimating()
            tableView.isUserInteractionEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Task {
            do {
                let itemsFetched = try await vm.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
                refreshItems(itemsFetched.saleItems, itemsFetched.threads)
            } catch {
                showNetworkError(error)
            }
        }
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
    private func refreshItems(_ saleItems: [SaleItem], _ threads: [MessageThread]) {
        vm.onFetch(saleItems, threads)
        reload()
    }
}
