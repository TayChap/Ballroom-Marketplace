//
//  SaleItemFilterVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-24.
//

import UIKit

class SaleItemFilterVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewControllerProtocol, PickerCellDelegate, SwitchCellDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemVM!
    var updateFilter: ((SaleItem) -> Void)?
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate], _ selectedTemplate: SaleItemTemplate, _ updateFilter: @escaping (SaleItem) -> Void) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.updateFilter = updateFilter
        vc.vm = SaleItemVM(owner: vc,
                           mode: .filter,
                           templates: templates,
                           selectedTemplate: selectedTemplate,
                           hideContactSeller: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = vm.title
        vm.viewDidLoad(with: tableView)
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
    @IBAction func doneButtonClicked() {
        vm.doneButtonClicked(updateFilter)
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
    func dismiss() {
        dismiss(animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - PickerCellDelegate
    func pickerUpdated(with newValues: [String], for cell: PickerTableCell) {
        setData(newValues.first ?? "", for: cell)
        reload()
    }
    
    // MARK: - SwitchCellDelegate
    func updateSwitchDetail(with isOn: Bool, for cell: SwitchTableCell) {
        vm.updateSwitchDetail(isOn, for: cell)
        reload()
    }
    
    // MARK: - Private Helpers
    /// Update the data in the DM
    /// - Parameters:
    ///   - data: data to update
    ///   - cell: cell corresponding to data to update
    private func setData(_ data: String, for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(data, at: indexPath)
    }
}
