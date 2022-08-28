//
//  SaleItemListVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-24.
//

import UIKit

class SaleItemListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, ViewControllerProtocol {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private var loadingSpinner: UIActivityIndicatorView?
    private var vm: SaleItemListVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(templates: [SaleItemTemplate],
                                     selectedTemplate: SaleItemTemplate,
                                     saleItems: [SaleItem]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemListVM(owner: vc,
                               templates: templates,
                               selectedTemplate: selectedTemplate,
                               unfilteredSaleItems: saleItems)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = vm.title
        vm.viewDidLoad(with: collectionView)
        loadingSpinner = addLoadingSpinner()
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
    @IBAction func filterButtonClicked() {
        vm.filterButtonClicked { saleItem in
            self.vm.orderSaleItems(by: saleItem)
            self.reload()
        }
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        vm.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        vm.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        vm.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        vm.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Task {
            loadingSpinner?.startAnimating()
            collectionView.isUserInteractionEnabled = false // on click, disable collection view to avoid double clicking
            await vm.collectionView(collectionView, didSelectItemAt: indexPath)
            loadingSpinner?.stopAnimating()
            collectionView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(_ vc: UIViewController) {
        present(NavigationController(rootViewController: vc), animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func reload() {
        collectionView.reloadData()
    }
}
