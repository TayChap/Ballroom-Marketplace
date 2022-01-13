//
//  SellVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import UIKit

class SellVC: UIViewController, ViewControllerProtocol, UITableViewDelegate, UITableViewDataSource, PickerCellDelegate, TextFieldCellDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate]) -> UIViewController {
        guard let vc = StoryboardManager().getVC(from: .main, of: self) else {
            assertionFailure("Can't Find VC in Storyboard")
            return UIViewController()
        }
        
        vc.vm = SaleItemVM(vc, templates)
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
    
    func reload() {
        tableView.reloadData()
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
    
    // MARK: - PickerCellDelegate
    func pickerValueUpdated(_ newValues: [String], for cell: PickerTableCell) {
        setData(newValues.first ?? "", for: cell)
        reload()
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(_ newText: String, for cell: TextFieldTableCell) {
        setData(newText, for: cell)
    }
    
    // MARK: - Private Helpers
    private func setData(_ data: String, for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(data, at: indexPath)
    }
}
