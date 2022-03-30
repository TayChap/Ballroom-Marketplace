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
        SaleItemCollectionCell.registerCell(collectionView)
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25 // TODO! remove magic numbers
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        saleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = saleItems[indexPath.item]
        guard let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(SaleItemCellDM(imageURL: cellData.images.map({ $0.url }).first ?? "",
                                          price: "$\(cellData.fields["price"] ?? "?")",
                                          date: cellData.dateAdded ?? Date())) // TODO should dateAdded be optional ?
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushViewController(SaleItemViewVC.createViewController(templates: templates,
                                                                         saleItem: saleItems[indexPath.item]))
    }
    
    // MARK: - Public Helpers
    mutating func updateFilter(_ filterSaleItem: SaleItem) { // TODO! update based on formalized templates
        var saleItemScores = [(item: SaleItem, score: Double)]()
        
        for saleItem in saleItems {
            var score = 0.0
            
            for filterField in filterSaleItem.fields {
                guard let itemStringValue = saleItem.fields[filterField.key] else {
                    // TODO! adjust score since not in field
                    continue
                }
                
                guard
                    let filterValue = Double(filterField.value),
                    let itemValue = Double(itemStringValue)
                else {
                    // TODO! it's a string like a template id or country
                    continue
                }
                
                score += abs(filterValue - itemValue)
            }
            
            saleItemScores.append((item: saleItem, score: score))
        }
        
        saleItems = saleItemScores.sorted(by: { $0.score < $1.score }).map({ $0.item }) // higher score means higher difference
    }
}