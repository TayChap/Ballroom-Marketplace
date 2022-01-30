//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct BuyVM {
    enum Section: Int, CaseIterable {
        case recentItems, categories
    }
    
    private weak var delegate: ViewControllerProtocol?
    private var templates: [SaleItemTemplate]?
    var saleItems = [SaleItem]() // TODO! private?
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        SaleItemCollectionCell.registerCell(collectionView)
        BuySectionHeader.registerCell(collectionView)
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard
            let templates = getTemplatesOrPresentError(),
            let user = getUserOrPresentLogin()
        else {
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController(templates)) // TODO! pass in user id
    }
    
    func inboxButtonClicked() {
        guard
            let templates = getTemplatesOrPresentError(),
            let user = getUserOrPresentLogin()
        else {
            return
        }
        
        DatabaseManager.sharedInstance.getThreads(with: user.id) { threads in
            delegate?.pushViewController(InboxVC.createViewController(user, threads, templates))
        }
    }
    
    // MARK: - CollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == Section.recentItems.rawValue ? saleItems.count : templates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Section.recentItems.rawValue {
            guard let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            let cellData = saleItems[indexPath.item]
            cell.configureCell(SaleItemCellDM(image: UIImage(), // TODO! refactor?
                                              price: "$50.00",
                                              date: cellData.dateAdded ?? Date()))
            return cell
        }
        
        // categories section
        guard let cell = CategoryCollectionCell.createCell(collectionView, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(CategoryCollectionCellDM(categoryTitle: templates?[indexPath.row].name ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Section.recentItems.rawValue {
            var cellData = saleItems[indexPath.row]
            let url = cellData.images.first?.url ?? ""
            ImageManager.sharedInstance.downloadImage(at: url) { data in
                cellData.images.insert(Image(url: url, data: data), at: 0)
                if let templates = templates {
                    delegate?.pushViewController(ViewItemVC.createViewController(templates, cellData))
                }
            }
            
            return
        }
        
        // categories section
        pushSaleItemList(with: "filter_example") // TODO!
    }
    
    // Public Helpers
    mutating func onTemplatesFetched(_ templates: [SaleItemTemplate]) {
        self.templates = templates
    }
    
    // Private Helpers
    private func getTemplatesOrPresentError() -> [SaleItemTemplate]? {
        guard let templates = templates else {
            // TODO! network error
            return nil
        }
        
        return templates
    }
    
    private func getUserOrPresentLogin() -> User? {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return nil
        }
        
        return user

    }
    
    private func pushSaleItemList(with filter: String? = nil) {
        guard let templates = templates else  {
            return
        }
        
        var templateFilter = (key: "fields.\(SaleItemTemplate.serverKey)", value: "shoes") // TODO!
        
        DatabaseManager.sharedInstance.getSaleItems(where: templateFilter) { filteredSaleItems in
            delegate?.pushViewController(SaleItemListVC.createViewController(templates, filteredSaleItems))
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch Section.allCases[sectionIndex] {
            case .recentItems: return self.generateRecentItemsLayout()
            case .categories: return self.generateCategoriesLayout()
            }
        }
    }
    
    private func generateRecentItemsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(180),
            heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = getGroupInsets()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [getSectionHeader()]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func generateCategoriesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = getGroupInsets()
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [getSectionHeader()]
        return section
    }
    
    private func getGroupInsets() -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    }
    
    private func getSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                       heightDimension: .estimated(44)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .top)
    }
}
