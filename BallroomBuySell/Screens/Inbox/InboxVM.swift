//
//  InboxVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

struct InboxVM {
    private weak var delegate: ViewControllerProtocol?
    private let user: User
    private let screenStructure: [MessageThread]
    private let templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ user: User, _ messageThreads: [MessageThread], _ templates: [SaleItemTemplate]) {
        delegate = owner
        self.user = user
        self.templates = templates
        screenStructure = messageThreads
    }
    
    // MARK: - IBActions
    func signOutButtonClicked() {
        AuthenticationManager().signOut {
            delegate?.dismiss()
        } onFail: {
            // TODO!
        }
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let thread = screenStructure[indexPath.row]
        
        guard
            let cell = InboxTableCell.createCell(tableView),
            let preview = thread.messages.last?.content
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(InboxCellDM(imageURL: thread.imageURL,
                                       userDisplayName: thread.messages.filter({ $0.displayName != user.displayName }).first?.displayName ?? "",
                                       messagePreview: preview))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = screenStructure[indexPath.row]
        delegate?.pushViewController(MessageThreadVC.createViewController(thread, user, templates))
    }
}
