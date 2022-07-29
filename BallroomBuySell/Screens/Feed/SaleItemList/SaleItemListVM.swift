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
    init(owner: ViewControllerProtocol,
         templates: [SaleItemTemplate],
         selectedTemplate: SaleItemTemplate,
         unfilteredSaleItems: [SaleItem]) {
        delegate = owner
        self.templates = templates
        self.selectedTemplate = selectedTemplate
        saleItems = unfilteredSaleItems
    }
    
    func viewDidLoad(with collectionView: UICollectionView) {
        EmptyListCollectionReusableView.registerCell(for: collectionView)
        SaleItemCollectionCell.registerCell(for: collectionView)
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        delegate?.dismiss()
    }
    
    func filterButtonClicked(_ completion: @escaping (SaleItem) -> Void) {
        delegate?.presentViewController(SaleItemVC.createViewController(mode: .filter,
                                                                        templates: templates,
                                                                        selectedTemplate: selectedTemplate) { saleItem in
            completion(saleItem)
        })
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: saleItems.count == 0 ? 50 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = EmptyListCollectionReusableView.createCell(for: collectionView,
                                                                      ofKind: kind,
                                                                      at: indexPath) else {
            return UICollectionReusableView()
        }
        
        header.configureCell(with: LocalizedString.string("list.empty.message"))
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
        guard let cell = SaleItemCollectionCell.createCell(for: collectionView, at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: SaleItemCellDM(imageURL: cellData.images.map({ $0.url }).first ?? "",
                                                price: "$\(cellData.fields["price"] ?? "?")", // TODO! hardcoded sale item field names
                                                location: Country.getCountryName(cellData.fields["location"]) ?? "?"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) async {
        if templates.isEmpty {
            return
        }
        
        var saleItem = saleItems[indexPath.item]
        saleItem.images = await Image.downloadImages(saleItem.images.map({ $0.url }))
        await delegate?.pushViewController(SaleItemVC.createViewController(mode: .view,
                                                                           templates: templates,
                                                                           saleItem: saleItem))
    }
    
    // MARK: - Public Helpers
    /// Re-orders the sale items based on the least differences from sale item passed in
    /// - Parameter filterSaleItem: Sale item to calculate the least differences from
    mutating func orderSaleItems(by filterSaleItem: SaleItem) {
        let filterFields = filterSaleItem.getFilterFields(basedOn: selectedTemplate)
        var saleItemScores = [(item: SaleItem, score: Double)]()
        
        for saleItem in saleItems {
            var score = 0.0
            let saleItemFields = saleItem.getFilterFields(basedOn: selectedTemplate)
            
            for filterField in filterFields {
                guard let itemStringValue = saleItemFields[filterField.key] else {
                    score += 100.0 // if field filtered for is not in sale item
                    continue
                }
                
                guard
                    let filterValue = Double(filterField.value),
                    let itemValue = Double(itemStringValue)
                else {
                    if filterField.value != itemStringValue {
                        score += 1000.0 // non-measurement fields prioritized in filtering
                    }
                    
                    continue
                }
                
                score += abs(filterValue - itemValue)
            }
            
            saleItemScores.append((item: saleItem, score: score))
        }
        
        saleItems = saleItemScores.sorted(by: { $0.score < $1.score }).map({ $0.item }) // higher score means higher difference
    }
}
