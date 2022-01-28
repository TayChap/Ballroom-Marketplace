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
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ user: User, _ messageThreads: [MessageThread]) {
        delegate = owner
        self.user = user
        screenStructure = messageThreads
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 //screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        guard let cell = InboxTableCell.createCell(tableView) else {
            return UITableViewCell()
        }
        
        cell.configureCell(InboxCellDM(saleItemImage: UIImage(),
                                       userDisplayName: "display",
                                       saleItem: "sale",
                                       messagePreview: "preview"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushViewController(MessageThreadVC.createViewController())
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete") // TODO
        }
    }
}
