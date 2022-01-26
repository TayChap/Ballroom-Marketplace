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
        
        // TODO! apply filtering
        
        saleItems = unfilteredSaleItems
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        // TODO! set view controller title (all items OR type)
        
        SaleItemCollectionCell.registerCell(collectionView)
    }
    
    // MARK: - IBActions
    func filterButtonClicked() {
        delegate?.presentViewController(SaleItemFilterVC.createViewController()) // TODO! pass in filter query
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 190, height: 200) // TODO! calculate based on itemsPerRow?
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        saleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        let cellData = saleItems[indexPath.item]
        cell.configureCell(SaleItemCellDM(image: UIImage(data: cellData.images.first?.data ?? Data()) ?? UIImage(), // TODO! refactor?
                                          price: "$50.00",
                                          date: cellData.dateAdded ?? Date())) // TODO should dateAdded be optional ?
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushViewController(ViewItemVC.createViewController(saleItems[indexPath.item]))
    }
}
