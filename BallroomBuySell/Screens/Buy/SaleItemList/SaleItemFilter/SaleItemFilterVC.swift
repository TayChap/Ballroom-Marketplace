//
//  SaleItemFilterVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-24.
//

import UIKit

class SaleItemFilterVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewControllerProtocol {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemFilterVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemFilterVM(vc, templates)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(tableView)
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClcked() {
        vm.backButtonClcked()
    }
    
    @IBAction func submitButtonClicked() {
        vm.submitButtonClicked()
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
    func dismiss() {
        dismiss(animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
}
