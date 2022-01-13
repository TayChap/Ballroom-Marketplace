//
//  SignUpVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class SignUpVC: UIViewController, UITableViewDataSource, ViewControllerProtocol, TextFieldCellDelegate {
    @IBOutlet weak var signUpButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm = SignUpVM()
    
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        UIViewController.getVC(from: .main, of: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(tableView)
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonClicked() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        vm.signUpButtonClicked(self) {
            self.signUpButton.isEnabled = true
        }
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
        dismiss(animated: true)
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(_ newText: String, for cell: TextFieldTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(newText, at: indexPath)
    }
}
