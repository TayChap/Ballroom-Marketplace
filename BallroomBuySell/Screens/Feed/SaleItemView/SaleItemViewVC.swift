//
//  SaleItemViewVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-13.
//

import AuthenticationServices
import UIKit

class SaleItemViewVC: UIViewController, UITableViewDataSource, ViewControllerProtocol, AuthenticatorProtocol, ImageCellDelegate, ButtonCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var vm: SaleItemVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(templates: [SaleItemTemplate], saleItem: SaleItem, hideContactSeller: Bool = false) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemVM(owner: vc, mode: .view, templates: templates, saleItem: saleItem, hideContactSeller: hideContactSeller)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad(with: tableView)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        vm.tableView(tableView, cellForRowAt: indexPath, self)
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        authorizationController(controller: controller, authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationController(controller: controller, error: error)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profilePictureSelected(info: info)
    }
    
    // MARK: - ButtonCellDelegate
    func buttonClicked() {
        vm.buttonClicked {
            signIn()
        }
    }
}
