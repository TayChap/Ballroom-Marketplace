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
    private let threads: [MessageThread]
    private var saleItems = [SaleItem]()
    private var inboxState = InboxState.threads
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ user: User, _ messageThreads: [MessageThread], _ templates: [SaleItemTemplate]) {
        delegate = owner
        self.user = user
        self.templates = templates
        threads = messageThreads
    }
    
    func viewDidLoad(_ completion: @escaping (_ saleItems: [SaleItem]) -> Void) {
        DatabaseManager.sharedInstance.getSaleItems(where: (key: SaleItem.QueryKeys.userId.rawValue, value: user.id)) { saleItems in
            completion(saleItems)
        }
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
                                  title: saleItem.fields[SaleItemTemplate.serverKey] ?? "",
                                  date: saleItem.dateAdded))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inboxState == .threads {
            delegate?.pushViewController(MessageThreadVC.createViewController(threads[indexPath.row], user, templates))
            return
        }
        
        var saleItem = saleItems[indexPath.row]
        Image.downloadImages(saleItem.images.map({ $0.url })) { images in
            saleItem.images = images
            delegate?.pushViewController(ViewItemVC.createViewController(templates, saleItem))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseManager.sharedInstance.deleteDocument(in: .threads, with: threads[indexPath.row].id) {
                delegate?.reload() // TODO! refresh data ?
            }
        }
    }
    
    // MARK: - Public Helpers
    mutating func onItemsFetched(_ saleItemsFetched: [SaleItem]) {
        saleItems = saleItemsFetched
    }
}
