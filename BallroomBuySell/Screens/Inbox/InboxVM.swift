//
//  InboxVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

struct InboxVM {
    enum InboxState: Int, CaseIterable {
        case threads, listings
    }
    
    private weak var delegate: ViewControllerProtocol?
    private let user: User
    private let templates: [SaleItemTemplate]
    private var threads = [MessageThread]()
    private var saleItems = [SaleItem]()
    private var inboxState = InboxState.threads
    
    // MARK: - Lifecycle Methods
    init(owner: ViewControllerProtocol, user: User, templates: [SaleItemTemplate]) {
        delegate = owner
        self.user = user
        self.templates = templates
    }
    
    func viewWillAppear(_ completion: @escaping (_ saleItems: [SaleItem], _ threads: [MessageThread]) -> Void) {
        DatabaseManager.sharedInstance.getSaleItems(where: (key: SaleItem.QueryKeys.userId.rawValue, value: user.id), { saleItems in
            DatabaseManager.sharedInstance.getThreads(for: user.id, { threads in
                completion(saleItems, threads)
            }, {
                delegate?.showNetworkError()
            })
        }, {
            delegate?.showNetworkError()
        })
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        delegate?.dismiss()
    }
    
    func signOutButtonClicked() {
        AuthenticationManager.sharedInstance.signOut {
            delegate?.dismiss()
        } onFail: {
            delegate?.showNetworkError()
        }
    }
    
    mutating func segmentedControlClicked(_ index: Int) {
        inboxState = InboxState.allCases.first(where: {$0.rawValue == index}) ?? .threads
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems() == 0 ? 1 : numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        if numberOfItems() == 0 { // empty message
            guard let cell = InboxEmptyTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: LocalizedString.string("list.empty.message"))
            return cell
        }
        
        guard let cell = InboxTableCell.createCell(for: tableView) else {
            return UITableViewCell()
        }
        
        if inboxState == .threads {
            let thread = threads[indexPath.row]
            guard let lastMessageUnwrapped = thread.messages.last else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: InboxCellDM(imageURL: thread.imageURL,
                                                 title: SaleItemTemplate.getItemTitle(by: thread.saleItemType, in: templates),
                                                 date: lastMessageUnwrapped.sentDate,
                                                 detail: "\(lastMessageUnwrapped.displayName): \(lastMessageUnwrapped.content)"))
            return cell
        }
        
        let saleItem = saleItems[indexPath.row]
        cell.configureCell(with: InboxCellDM(imageURL: saleItem.images.first?.url ?? "",
                                             title: SaleItemTemplate.getItemTitle(by: saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] ?? "", in: templates),
                                             date: saleItem.dateAdded))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if numberOfItems() == 0 { // empty message
            return
        }
        
        if inboxState == .threads {
            delegate?.pushViewController(MessageThreadVC.createViewController(threads[indexPath.row],
                                                                              user: user,
                                                                              templates: templates))
            return
        }
        
        var saleItem = saleItems[indexPath.row]
        Image.downloadImages(saleItem.images.map({ $0.url })) { images in
            saleItem.images = images
            delegate?.pushViewController(SaleItemViewVC.createViewController(templates: templates,
                                                                             saleItem: saleItem))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath, completion: @escaping (_ saleItems: [SaleItem], _ threads: [MessageThread]) -> Void) {
        if editingStyle == .delete {
            if inboxState == .threads {
                DatabaseManager.sharedInstance.deleteDocument(in: .threads, with: threads[indexPath.row].id, {
                    fetchItems(completion)
                }, onFail)
            } else {
                DatabaseManager.sharedInstance.deleteSaleItem(with: saleItems[indexPath.row].id, {
                    fetchItems(completion)
                }, onFail)
            }
        }
    }
    
    // MARK: - Public Helpers
    mutating func onFetch(_ saleItemsFetched: [SaleItem], _ threadsFetched: [MessageThread]) {
        saleItems = saleItemsFetched.sorted(by: { $0.dateAdded.compare($1.dateAdded) == .orderedDescending })
        
        // sort and filter threads
        threads = threadsFetched.sorted(by: { $0.messages.last?.sentDate.compare($1.messages.last?.sentDate ?? Date()) == .orderedDescending })
    }
    
    // MARK: - Private Helpers
    /// Query server for both sale items and threads
    /// - Parameter completion: on successfully fetching the saleItem and thread data
    private func fetchItems(_ completion: @escaping (_ saleItems: [SaleItem], _ threads: [MessageThread]) -> Void) {
        DatabaseManager.sharedInstance.getSaleItems(where: (key: SaleItem.QueryKeys.userId.rawValue, value: user.id), { saleItems in
            DatabaseManager.sharedInstance.getThreads(for: user.id, { threads in
                completion(saleItems, threads)
            }, {
                delegate?.showNetworkError()
            })
        }, {
            delegate?.showNetworkError()
        })
    }
    
    /// Displays a network error on failied query
    private func onFail() {
        delegate?.showNetworkError()
    }
    
    /// get total number of items for the currently active state
    /// - Returns: number of items for currently active state
    private func numberOfItems() -> Int {
        inboxState == .threads ? threads.count : saleItems.count
    }
}
