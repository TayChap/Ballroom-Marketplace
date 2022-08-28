//
//  LoginVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class LoginVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol, TextFieldCellDelegate {
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: LoginVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        let vc = UIViewController.getVC(from: .staging, of: self)
        vc.vm = LoginVM(delegate: vc)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(with: tableView)
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonClicked() {
        dismiss()
    }
    
    @IBAction func addUserButtonClicked() {
        vm.addUserButtonClicked()
    }
    
    @IBAction func loginButtonClicked() {
        vm.loginButtonClicked(self)
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(with newText: String, for cell: TextFieldTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(newText, at: indexPath)
    }
}
