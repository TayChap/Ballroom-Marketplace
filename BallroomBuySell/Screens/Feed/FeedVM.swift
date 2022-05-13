//
//  FeedVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct FeedVM {
    enum Section: Int, CaseIterable {
        case recentItems, categories
    }
    
    private weak var delegate: (ViewControllerProtocol & AuthenticatorProtocol)?
    private var templates = [SaleItemTemplate]()
    private var saleItems = [SaleItem]()
    private var maxRecentItems: Int { 20 }
    
    // MARK: - Lifecycle Methods
    init(delegate: ViewControllerProtocol & AuthenticatorProtocol) {
        self.delegate = delegate
    }
    
    func viewDidLoad(with collectionView: UICollectionView) {
        collectionView.collectionViewLayout = createCollectionViewLayout(for: collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:  UICollectionViewCell.defaultRegister)
        SaleItemCollectionCell.registerCell(for: collectionView)
        FeedSectionHeader.registerCell(for: collectionView)
        
//        TemplateManager.updateTemplates()
    }
    
    func viewWillAppear(_ completion: @escaping (_ templates: [SaleItemTemplate], _ saleItems: [SaleItem]) -> Void) {
        // refresh templates and pull most recent sale items
        DatabaseManager.sharedInstance.getDocuments(to: .templates,
                                                    of: SaleItemTemplate.self) { templates in
            DatabaseManager.sharedInstance.getDocuments(to: .items,
                                                        of: SaleItem.self,
                                                        withOrderRule: (field: SaleItem.QueryKeys.dateAdded.rawValue, descending: true, limit: maxRecentItems)) { items in
                completion(templates, items)
            } onFail: {
                delegate?.showNetworkError()
            }
        } onFail: {
            delegate?.showNetworkError()
        }
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        if AuthenticationManager.sharedInstance.user == nil {
            delegate?.signIn()
            return
        }
        
        if templates.isEmpty {
            delegate?.showNetworkError()
            return
        }
        
        delegate?.pushViewController(SaleItemVC.createViewController(mode: .create,
                                                                 templates: templates))
    }
    
    func inboxButtonClicked() {
        guard let user = AuthenticationManager.sharedInstance.user else {
            delegate?.signIn()
            return
        }
        
        if templates.isEmpty {
            delegate?.showNetworkError()
            return
        }
        
        delegate?.pushViewController(InboxVC.createViewController(user, templates))
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = FeedSectionHeader.createCell(for: collectionView,
                                                               ofKind: kind,
                                                               at: indexPath) else {
            return UICollectionReusableView()
        }
        
        sectionHeader.configureCell(with: LocalizedString.string(indexPath.section == 0 ? "feed.recent.items" : "generic.category"))
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
                let cell = SaleItemCollectionCell.createCell(for: collectionView, at: indexPath),
                let coverImageURL = cellData.images.first?.url
            else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell
                                                            .defaultRegister, for: indexPath)
            }
            
            cell.configureCell(with: SaleItemCellDM(imageURL: coverImageURL,
                                                    price: "$\(cellData.fields["price"] ?? "?")",
                                                    date: cellData.dateAdded))
            return cell
        }
        
        // categories section
        guard let cell = CategoryCollectionCell.createCell(for: collectionView, at: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier:  UICollectionViewCell.defaultRegister, for: indexPath)
        }
        
        let template = templates[indexPath.row]
        cell.configureCell(with: CategoryCollectionCellDM(categoryTitle: LocalizedString.string(template.name),
                                                          imageURL: template.imageURL))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void) {
        if indexPath.section == Section.recentItems.rawValue {
            var saleItem = saleItems[indexPath.row]
            Image.downloadImages(saleItem.images.map({ $0.url })) { images in
                if !templates.isEmpty {
                    saleItem.images = images
                    delegate?.pushViewController(SaleItemVC.createViewController(mode: .view,
                                                                             templates: templates,
                                                                             saleItem: saleItem))
                }
            }
            
            completion()
            return
        }
        
        // category selected
        let selectedTemplate = templates[indexPath.row]
        let templateFilter = (key: "fields.\(SaleItemTemplate.serverKey.templateId.rawValue)", value: selectedTemplate.id)
        DatabaseManager.sharedInstance.getDocuments(to: .items,
                                                    of: SaleItem.self,
                                                    whereFieldEquals: templateFilter) { filteredSaleItems in
            delegate?.pushViewController(SaleItemListVC.createViewController(templates: templates,
                                                                             selectedTemplate: selectedTemplate,
                                                                             saleItems: filteredSaleItems))
            completion()
        } onFail: {
            delegate?.showNetworkError()
            completion()
        }
    }
    
    // MARK: - Public Helpers
    mutating func onItemsFetched(templatesFetched: [SaleItemTemplate], saleItemsFetched: [SaleItem]) {
        templates = templatesFetched.sorted(by: { $0.order < $1.order })
        saleItems = saleItemsFetched
    }
    
    // MARK: - CompositionalLayout Methods
    /// Generate the  layout for the given collection view
    /// - Parameter collectionView: the collection view to assign the layout to
    /// - Returns: the layout for the collection view
    private func createCollectionViewLayout(for collectionView: UICollectionView) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch Section.allCases[sectionIndex] {
            case .recentItems: return self.generateRecentItemsLayout(for: collectionView)
            case .categories: return self.generateCategoriesLayout(for: collectionView)
            }
        }
    }
    
    /// Generate the layout for the recent items section in the collection view
    /// - Parameter collectionView:the collection view to generate the layout for
    /// - Returns: the layout for the recent items section in the collection view
    private func generateRecentItemsLayout(for collectionView: UICollectionView) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let width = collectionView.frame.width / 2.5
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(width * 1.4))
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
    
    /// Generate the layout for the category items section in the collection view
    /// - Parameter collectionView:the collection view to generate the layout for
    /// - Returns: the layout for the recent items section in the collection view
    private func generateCategoriesLayout(for collectionView: UICollectionView) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(collectionView.frame.width),
            heightDimension: .absolute((collectionView.frame.width / 2) * (4/3)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
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
