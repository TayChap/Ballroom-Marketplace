//
//  SaleItemListVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

struct SaleItemListVM {
    weak var delegate: ViewControllerProtocol?
    private var saleItems: [SaleItem]
    // TODO! private var filter: Filter
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ unfilteredSaleItems: [SaleItem]) {
        delegate = owner
        
        // TODO apply filtering
        
        saleItems = unfilteredSaleItems
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        SaleItemCollectionCell.registerCell(collectionView)
    }
    
    // MARK: - IBActions
    func filterButtonClicked() {
        delegate?.pushViewController(SaleItemFilterVC.createViewController()) // TODO! pass in filter query
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        saleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        SaleItemCollectionCell.createCell(collectionView, for: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
