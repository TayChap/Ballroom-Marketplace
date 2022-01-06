//
//  LoginVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct LoginVM {
    enum LoginItem: CaseIterable {
        case email
        case password
        case signUp
        
        var text: String {
            switch self {
            case .email: return "email"
            case .password: return "password"
            case .signUp: return "Sign Up"
            }
        }
        
        var type: TextFieldTableCell.InputType {
            switch self {
            case .email: return .email
            case .password: return .password
            default: return .standard
            }
        }
        
        var returnKeyType: UIReturnKeyType {
            switch self {
            case .password: return .done
            default: return .next
            }
        }
        
        var hasData: Bool {
            self != .signUp
        }
    }
    
    private var dm = [LoginItem: String]()
    
    // MARK: - Lifecycle Methods
    init() {
        for item in LoginItem.allCases where item.hasData {
            dm[item] = ""
        }
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        TextFieldTableCell.registerCell(tableView)
        ButtonTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    func loginButtonClicked(_ delegate: ViewControllerProtocol, _ enableButton: () -> Void) {
        guard
            let email = dm[LoginItem.email],
            let password = dm[LoginItem.password]
        else {
            return
        }
        
        AuthenticationManager().login(email: email, password: password) {
            delegate.dismiss()
        } onFail: { errorMessage in
            delegate.showAlertWith(message: errorMessage)
        }
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LoginItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellData = LoginItem.allCases[indexPath.row]
        // button cell
        if cellData == .signUp {
            guard let cell = ButtonTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(cellData.text)
            cell.delegate = owner as? ButtonCellDelegate
            return cell
        }
        
        // text field cell
        guard let cell = TextFieldTableCell.createCell(tableView) else {
            return UITableViewCell()
        }
        
        cell.configureCell(TextFieldCellDM(type: cellData.type,
                                           title: cellData.text,
                                           detail: dm[cellData] ?? "",
                                           returnKeyType: .done))
        cell.delegate = owner as? TextFieldCellDelegate
        return cell
    }
    
    // MARK: - ButtonCellDelegate
    func buttonClicked(_ owner: ViewControllerProtocol) {
        owner.pushViewController(SignUpVC.createViewController())
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[LoginItem.allCases[indexPath.row]] = data
    }
}
