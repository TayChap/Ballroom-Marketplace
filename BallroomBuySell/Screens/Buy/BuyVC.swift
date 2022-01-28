//
//  BuyVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class BuyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ViewControllerProtocol {
    @IBOutlet weak var sellButton: UIBarButtonItem!
    @IBOutlet weak var inboxButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private var vm: BuyVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = BuyVM(self)
        vm.viewDidLoad(collectionView)
        
        TemplateManager().refreshTemplates { templates in
            self.vm.onTemplatesFetched(templates)
            
            DatabaseManager.sharedInstance.getSaleItems() { saleItems in
                self.vm.saleItems = saleItems
                self.reload()
            }
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
        guard let sectionHeader = BuySectionHeader.createCell(collectionView, ofKind: kind, for: indexPath) else {
            return UICollectionReusableView()
        }
        
        sectionHeader.configureCell("blah blah")
        return sectionHeader
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
}
