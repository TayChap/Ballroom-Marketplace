//
//  FeedVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import AuthenticationServices
import UIKit

class FeedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ViewControllerProtocol, AuthenticatorProtocol {
    @IBOutlet weak var sellButton: UIBarButtonItem!
    @IBOutlet weak var inboxButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private var vm: FeedVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = FeedVM(self)
        vm.viewDidLoad(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear { templates, saleItems in
            self.vm.onItemsFetched(templates, saleItems)
            self.reload()
        }
    }
    
    // MARK: - IBActions
    @IBAction func sellButtonClicked() {
        vm.sellButtonClicked()
    }
    
    @IBAction func inboxButtonClicked() {
        vm.inboxButtonClicked()
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        vm.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        vm.numberOfSections(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        vm.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
    
    func reload() {
        collectionView.reloadData()
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
}