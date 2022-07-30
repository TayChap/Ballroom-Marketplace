//
//  ProfileVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDataSource, ViewControllerProtocol, ImageCellDelegate, TextFieldCellDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var updateUserButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var vm: ProfileVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(user: User, photo: Image?) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = ProfileVM(user: user, photo: photo, delegate: vc)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(with: tableView)
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
    @IBAction func updateUserButtonClicked() {
        vm.updateUserButtonClicked()
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
        navigationController?.popViewController(animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - ImageCellDelegate
    func addImages(_ images: [Data]) {
        guard let image = images.first else {
            return
        }
        
        vm.newImage(image)
        reload()
    }
    
    func deleteImage(at index: Int) {
        vm.deleteImage(at: index)
        reload()
    }
    
    // MARK: - TextFieldCellDelegate
    func textFieldUpdated(with newText: String, for cell: TextFieldTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        vm.setData(newText, at: indexPath)
    }
}
