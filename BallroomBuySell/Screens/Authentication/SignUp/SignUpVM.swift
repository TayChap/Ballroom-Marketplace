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
        
        var type: TextFieldTableCell.InputType {
            switch self {
            case .email: return .email
            case .name: return .standard
            case .password: return .password
            }
        }
        
        var returnKeyType: UIReturnKeyType {
            switch self {
            case .password: return .done
            default: return .next
            }
        }
    }
    
    private weak var delegate: ViewControllerProtocol? // TODO! potentially remove
    private var dm = [String].init(repeating: "", count: SignUpItem.allCases.count)
    
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
        cell.configureCell(TextFieldCellDM(type: cellData.type,
                                           title: cellData.text,
                                           detail: dm[indexPath.row],
                                           returnKeyType: .done))
        
        cell.delegate = owner as? TextFieldCellDelegate
        return cell
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[indexPath.row] = data
    }
}
