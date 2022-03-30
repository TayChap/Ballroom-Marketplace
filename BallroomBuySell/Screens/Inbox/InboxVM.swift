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
    init(_ owner: ViewControllerProtocol, _ user: User, _ templates: [SaleItemTemplate]) {
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
    func signOutButtonClicked() {
        AuthenticationManager().signOut {
            delegate?.dismiss()
        } onFail: {
            // TODO!
        }
    }
    
    mutating func segmentedControlClicked(_ index: Int) {
        inboxState = InboxState.allCases.first(where: {$0.rawValue == index}) ?? .threads
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inboxState == .threads ? threads.count : saleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        guard let cell = InboxTableCell.createCell(tableView) else {
            return UITableViewCell()
        }
        
        if inboxState == .threads {
            let thread = threads[indexPath.row]
            guard let lastMessageUnwrapped = thread.messages.last else {
                return UITableViewCell()
            }
            
            cell.configureCell(InboxCellDM(imageURL: thread.imageURL,
                                      title: thread.title,
                                      date: lastMessageUnwrapped.sentDate,
                                      detail: "\(lastMessageUnwrapped.displayName): \(lastMessageUnwrapped.content)"))
            return cell
        }
        
        let saleItem = saleItems[indexPath.row]
        cell.configureCell(InboxCellDM(imageURL: saleItem.images.first?.url ?? "",
                                       title: saleItem.fields[SaleItemTemplate.serverKey.templateId.rawValue] ?? "",
                                       date: saleItem.dateAdded))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        saleItems = saleItemsFetched
        threads = threadsFetched
    }
    
    // MARK: - Private Helpers
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
    
    private func onFail() {
        delegate?.showNetworkError()
    }
}
