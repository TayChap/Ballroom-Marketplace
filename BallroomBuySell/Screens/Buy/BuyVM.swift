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
    
    private weak var delegate: (ViewControllerProtocol & AuthenticatorProtocol)?
    private var templates = [SaleItemTemplate]() // TODO! change to an optional (no empty case)
    private var saleItems = [SaleItem]()
    private var maxRecentItems: Int { 20 }
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol & AuthenticatorProtocol) {
        self.delegate = delegate
    }
    
    func viewDidLoad(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:  UICollectionViewCell.defaultRegister)
        SaleItemCollectionCell.registerCell(collectionView)
        BuySectionHeader.registerCell(collectionView)
        
        //TemplateManager.updateTemplates()
    }
    
    func viewWillAppear(_ completion: @escaping (_ templates: [SaleItemTemplate], _ saleItems: [SaleItem]) -> Void) {
        // refresh templates and pull most recent sale items
        TemplateManager.refreshTemplates { templates in
            DatabaseManager.sharedInstance.getRecentSaleItems(for: maxRecentItems) { items in
                completion(templates, items)
            }
        }
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        if AuthenticationManager().user == nil {
            delegate?.signIn()
            return
        }
        
        if templates.isEmpty {
            networkError()
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController(templates))
    }
    
    func inboxButtonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.signIn()
            return
        }
        
        if templates.isEmpty {
            networkError()
            return
        }
        
        delegate?.pushViewController(InboxVC.createViewController(user, templates))
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = BuySectionHeader.createCell(collectionView, ofKind: kind, for: indexPath) else {
            return UICollectionReusableView()
        }
        
        sectionHeader.configureCell(indexPath.section == 0 ? "recent_items" : "categories")
        return sectionHeader
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == Section.recentItems.rawValue ? saleItems.count : templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Section.recentItems.rawValue {
            let cellData = saleItems[indexPath.item]
            
            guard
                let cell = SaleItemCollectionCell.createCell(collectionView, for: indexPath),
                let coverImageURL = cellData.images.first?.url
            else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell
                                                            .defaultRegister, for: indexPath)
            }
            
            cell.configureCell(SaleItemCellDM(imageURL: coverImageURL,
                                              price: "$50.00",
                                              date: cellData.dateAdded ?? Date()))
            return cell
        }
        
        // categories section
        guard let cell = CategoryCollectionCell.createCell(collectionView, for: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier:  UICollectionViewCell.defaultRegister, for: indexPath)
        }
        
        let template = templates[indexPath.row]
        cell.configureCell(CategoryCollectionCellDM(categoryTitle: template.name,
                                                    imageURL: template.imageURL))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Section.recentItems.rawValue {
            var saleItem = saleItems[indexPath.row]
            Image.downloadImages(saleItem.images.map({ $0.url })) { images in
                if !templates.isEmpty {
                    saleItem.images = images
                    delegate?.pushViewController(SaleItemViewVC.createViewController(templates: templates,
                                                                                     saleItem: saleItem))
                }
            }
            
            return
        }
        
        var templateFilter = (key: "fields.\(SaleItemTemplate.serverKey)", value: templates[indexPath.row].id)
        DatabaseManager.sharedInstance.getSaleItems(where: templateFilter) { filteredSaleItems in
            delegate?.pushViewController(SaleItemListVC.createViewController(templates, filteredSaleItems))
        }
    }
    
    // MARK: - Public Helpers
    mutating func onItemsFetched(_ templatesFetched: [SaleItemTemplate], _ saleItemsFetched: [SaleItem]) {
        templates = templatesFetched
        saleItems = saleItemsFetched
    }
    
    // MARK: - Private Helpers
    private func networkError() {
        // TODO! please connect to the internet
    }
    
    // MARK: - CompositionalLayout Methods
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
