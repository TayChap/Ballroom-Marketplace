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
        case displayName
        case password
        
        var text: String {
            switch self {
            case .email: return "email"
            case .displayName: return "name"
            case .password: return "password"
            }
        }
        
        var type: TextFieldTableCell.InputType {
            switch self {
            case .email: return .email
            case .displayName: return .standard
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
    
    private var dm = [SignUpItem: String]()
    
    // MARK: - Lifecycle Methods
    init() {
        for item in SignUpItem.allCases {
            dm[item] = ""
        }
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        TextFieldTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    func signUpButtonClicked(_ delegate: ViewControllerProtocol, _ enableButton: () -> Void) {
        guard // validity of email and password checked on server side
            let email = dm[SignUpItem.email],
            let password = dm[SignUpItem.password],
            let displayName = dm[SignUpItem.displayName], !displayName.isEmpty
        else {
            return // TODO! please fill out all required fields
        }
        
        AuthenticationManager().createUser(email: email,
                                           password: password,
                                           displayName: displayName) {
            delegate.dismiss()
        }
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
                                           detail: dm[cellData] ?? "",
                                           returnKeyType: .done))
        
        cell.delegate = owner as? TextFieldCellDelegate
        return cell
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[SignUpItem.allCases[indexPath.row]] = data
    }
}
