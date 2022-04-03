//
//  SaleItemListVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-25.
//

import UIKit

struct SaleItemListVM {
    // MARK: - Stored Properties
    private weak var delegate: ViewControllerProtocol?
    private var saleItems: [SaleItem]
    private let selectedTemplate: SaleItemTemplate
    private let templates: [SaleItemTemplate]
    
    // MARK: Computed Properties
    var title: String {
        LocalizedString.string(selectedTemplate.name)
    }
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ templates: [SaleItemTemplate], _ selectedTemplate: SaleItemTemplate, _ unfilteredSaleItems: [SaleItem]) {
        delegate = owner
        self.templates = templates
        self.selectedTemplate = selectedTemplate
        saleItems = unfilteredSaleItems
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        EmptyListCollectionReusableView.registerCell(collectionView)
        SaleItemCollectionCell.registerCell(collectionView)
    }
    
    // MARK: - IBActions
    func filterButtonClicked(_ completion: @escaping (SaleItem) -> Void) {
        delegate?.presentViewController(SaleItemFilterVC.createViewController(templates, selectedTemplate) { saleItem in
            completion(saleItem)
        })
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: saleItems.count == 0 ? 50 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = EmptyListCollectionReusableView.createCell(collectionView, ofKind: kind, for: indexPath) else {
            return UICollectionReusableView()
        }
        
        header.configureCell(LocalizedString.string("list.empty.message"))
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
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
                                          date: cellData.dateAdded ?? Date()))
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
