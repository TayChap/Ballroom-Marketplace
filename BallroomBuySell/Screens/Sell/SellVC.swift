//
//  SellVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-28.
//

import UIKit

class SellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerProtocol, PickerCellDelegate, TextFieldCellDelegate, ImageCellDelegate, SwitchCellDelegate, TextViewCellDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemVM(vc, mode: .create, templates: templates)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // For RTP Notes, shift up table when keyboard covers field
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardChange(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        tableView.contentInset.bottom = keyboardRect.height
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        tableView.contentInset.bottom = 0
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
    
    // MARK: - SwitchCellDelegate
    func updateSwitchDetail(_ newValue: Bool, for cell: SwitchTableCell) {
        vm.updateSwitchDetail(newValue, for: cell)
        reload()
    }
    
    // MARK: - TextViewCellDelegate
    func textDidBeginEditing(_ cell: TextViewTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func updateTextViewDetail(_ newText: String, for cell: TextViewTableCell) {
        setData(newText, for: cell)
        tableView.performBatchUpdates(nil, completion: nil) // Need to adjust cell height without reloading the table view
    }
    
    // MARK: - Private Helpers
    private func setData(_ data: String, for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(data, at: indexPath)
    }
}
