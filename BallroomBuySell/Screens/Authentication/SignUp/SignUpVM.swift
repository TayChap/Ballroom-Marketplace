//
//  SignUpVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct SignUpVM {
    enum SignUpItem: CaseIterable {
        case email
        case name
        case password
        
        var text: String {
            switch self {
            case .email: return "email"
            case .name: return "name"
            case .password: return "password"
            }
        }
    }
    
    private weak var delegate: ViewControllerProtocol? // TODO! potentially remove
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol) {
        delegate = owner
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        TextFieldTableCell.registerCell(tableView)
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignUpItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        guard let cell = TextFieldTableCell.createCell(tableView) else {
            return UITableViewCell()
        }
        
        let cellData = SignUpItem.allCases[indexPath.row]
        cell.configureCell(TextFieldCellDM(type: .standard,
                                           title: cellData.text,
                                           detail: "ok ok",
                                           returnKeyType: .done))
        
        cell.delegate = owner as? TextFieldCellDelegate
        return cell
    }
    
    // MARK: - StandardTextField Delegate
    mutating func textFieldUpdated(_ newText: String) {
        // TODO!
    }
}
