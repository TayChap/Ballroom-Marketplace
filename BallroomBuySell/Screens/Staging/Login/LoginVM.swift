//
//  LoginVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct LoginVM: ViewModelProtocol {
    enum LoginItem: CaseIterable {
        case email
        
        var text: String {
            switch self {
            case .email: return "email"
            }
        }
        
        var type: InputType {
            .email
        }
        
        var returnKeyType: UIReturnKeyType {
            switch self {
            default: return .next
            }
        }
    }
    
    private var dm = [LoginItem: String]()
    
    // MARK: - Lifecycle Methods
    init() {
        for item in LoginItem.allCases {
            dm[item] = ""
        }
    }
    
    func viewDidLoad(with tableView: UITableView) {
        TextFieldTableCell.registerCell(for: tableView)
    }
    
    // MARK: - IBActions
    func addUserButtonClicked() {
        guard let email = dm[LoginItem.email] else {
            return
        }
        
        do {
            let codableUser = User(id: UUID().uuidString,
                                   email: email,
                                   photoURL: nil,
                                   displayName: "Staging User")
            try DatabaseManager.sharedInstance.putDocument(in: .users,
                                                           for: codableUser)
        } catch {
            //
        }
    }
    
    func loginButtonClicked(_ delegate: ViewControllerProtocol) {
        guard let email = dm[LoginItem.email] else {
            return
        }
        
        Task {
            do {
                try await AuthenticationManager.sharedInstance.loginStagingUser(email: email)
                delegate.dismiss()
            } catch {
                delegate.showNetworkError(error)
            }
        }
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LoginItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellData = LoginItem.allCases[indexPath.row]
        guard let cell = TextFieldTableCell.createCell(for: tableView) else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: TextFieldCellDM(inputType: cellData.type,
                                                 title: cellData.text,
                                                 detail: dm[cellData] ?? "",
                                                 returnKeyType: .done))
        cell.delegate = owner as? TextFieldCellDelegate
        return cell
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[LoginItem.allCases[indexPath.row]] = data
    }
}
