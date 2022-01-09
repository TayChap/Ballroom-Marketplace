//
//  SellVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import UIKit

class SellVC: UIViewController, ViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: SellVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate]) -> UIViewController {
        guard let vc = StoryboardManager().getMain().instantiateViewController(withIdentifier: String(describing: SellVC.self)) as? SellVC else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        vc.vm = SellVM(vc, templates)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.viewDidLoad(tableView)
    }
    
    // MARK: - IBActions
    @IBAction func doneButtonClicked() {
        vm.doneButtonClicked()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.tableView(tableView, didSelectRowAt: indexPath, self)
//        tableView.reloadData() // TODO! evaluate
//        checkRequiredFields()
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(_ newText: String, for cell: TextFieldTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(newText, at: indexPath)
    }
}
