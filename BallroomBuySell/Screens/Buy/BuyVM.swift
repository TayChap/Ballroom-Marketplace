//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct BuyVM {
    private weak var delegate: ViewControllerProtocol?
    private var templates: [SaleItemTemplate]?
    var screenStructure = [SaleItem]()
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard let templates = templates else {
            // TODO! network error
            return
        }
        
        guard let _ = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController(templates))
    }
    
    func profileButtonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(ProfileVC.createViewController(user))
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            //let cellData = saleItems[indexPath.item]
            cell.configureCell(SaleItemCellDM(image: UIImage(), // TODO! refactor?
                                              price: "$50.00",
                                              date: Date())) // TODO should dateAdded be optional ?
            return cell
        }
        
        guard let cell = CategoryCollectionCell.createCell(collectionView, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(CategoryCollectionCellDM(categoryTitle: "HI HI"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        var cellData = screenStructure[indexPath.row]
        //        let url = cellData.images.first?.url ?? ""
        //        ImageManager.sharedInstance.downloadImage(at: url) { data in
        //            cellData.images.insert(Image(url: url, data: data), at: 0)
        //            delegate?.pushViewController(ViewItemVC.createViewController(cellData))
        //        }
        
        guard let templates = templates else  {
            return
        }

        // TODO! need to pass in some sort of filter item
        delegate?.pushViewController(SaleItemListVC.createViewController(templates, screenStructure))
    }
    
    // Public Helpers
    mutating func onTemplatesFetched(_ templates: [SaleItemTemplate]) {
        self.templates = templates
    }
}
