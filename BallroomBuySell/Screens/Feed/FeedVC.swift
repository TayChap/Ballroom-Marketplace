//
//  FeedVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class FeedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ViewControllerProtocol {
    @IBOutlet weak var sellButton: UIBarButtonItem!
    @IBOutlet weak var inboxButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private var loadingSpinner: UIActivityIndicatorView?
    private var vm: FeedVM!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = FeedVM(delegate: self)
        vm.viewDidLoad(with: collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        loadingSpinner = addLoadingSpinner()
        refreshData()
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
    
    func reload() {
        collectionView.reloadData()
    }
    
    // MARK: - Private Helpers
    @objc private func refreshData() {
        Task {
            do {
                let fetchedItems = try await vm.fetchItems()
                self.vm.onItemsFetched(templatesFetched: fetchedItems.templates,
                                       saleItemsFetched: fetchedItems.saleItems)
                self.reload()
                self.refreshControl.endRefreshing()
            } catch {
                showNetworkError(error)
            }
        }
    }
}
