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
    @IBOutlet weak var tableView: UITableView! // TODO! update to collection view
    private var vm: BuyVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = BuyVM(self)
        
        TemplateManager().refreshTemplates { templates in
            self.vm.onTemplatesFetched(templates)
            
            DatabaseManager.sharedInstance.getSaleItems(where: (key: "fields.\(SaleItemTemplate.serverKey)", value: "shoes")) { saleItems in
                self.vm.screenStructure = saleItems
                self.reload()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func sellButtonClicked() {
        vm.sellButtonClicked()
    }
    
    @IBAction func profileButtonClicked() {
        vm.profileButtonClicked()
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
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
}
