//
//  SellVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import UIKit

class SellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol, PickerCellDelegate, TextFieldCellDelegate, ImageCellDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
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
    
    // MARK: - IBActions
    @IBAction func doneButtonClicked() {
        doneButton.isEnabled = false
        vm.doneButtonClicked()
        dismiss()
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true) // dismiss keyboard on row selection
        vm.tableView(tableView, didSelectRowAt: indexPath, self)
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
    
    // MARK: - PickerCellDelegate
    func pickerValueUpdated(_ newValues: [String], for cell: PickerTableCell) {
        setData(newValues.first ?? "", for: cell)
        reload()
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(_ newText: String, for cell: TextFieldTableCell) {
        setData(newText, for: cell)
    }
    
    // MARK: - ImageCellDelegate
    func newImage(_ data: Data) {
        vm.newImage(data)
        reload()
    }
    
    func deleteImage(at index: Int) {
        vm.deleteImage(at: index)
        reload()
    }
    
    // MARK: - Private Helpers
    private func setData(_ data: String, for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(data, at: indexPath)
    }
}
