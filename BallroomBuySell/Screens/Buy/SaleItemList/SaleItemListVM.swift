//
//  SaleItemListVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

struct SaleItemListVM {
    private weak var delegate: ViewControllerProtocol?
    private var saleItems: [SaleItem]
    private(set) var templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ templates: [SaleItemTemplate], _ unfilteredSaleItems: [SaleItem]) {
        delegate = owner
        self.templates = templates
        
        saleItems = unfilteredSaleItems
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        // TODO! set view controller title (all items OR type)
        SaleItemCollectionCell.registerCell(collectionView)
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 190, height: 200) // TODO! calculate based on itemsPerRow?
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        saleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = saleItems[indexPath.item]
        
        guard
            let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath),
            let coverImageURL = cellData.images.map({ $0.url }).first
        else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(SaleItemCellDM(imageURL: coverImageURL,
                                          price: "$50.00",
                                          date: cellData.dateAdded ?? Date())) // TODO should dateAdded be optional ?
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushViewController(ViewItemVC.createViewController(templates, saleItems[indexPath.item]))
    }
}
