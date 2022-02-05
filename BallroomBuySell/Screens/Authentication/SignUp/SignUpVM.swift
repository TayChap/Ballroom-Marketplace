//
//  SignUpVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct SignUpVM {
    enum SignUpItem: CaseIterable {
        case photo
        case email
        case displayName
        case password
        
        var text: String {
            switch self {
            case .photo: return "photo"
            case .email: return "email"
            case .displayName: return "name"
            case .password: return "password"
            }
        }
        
        var type: InputType {
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
    }
    
    weak var delegate: ViewControllerProtocol?
    private var photo: SaleItemImage?
    private var dm = [SignUpItem: String]()
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
        for item in SignUpItem.allCases {
            dm[item] = ""
        }
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        ImageTableCell.registerCell(tableView)
        TextFieldTableCell.registerCell(tableView)
    }
    
    // MARK: - IBActions
    func signUpButtonClicked(_ delegate: ViewControllerProtocol, _ enableButton: @escaping () -> Void) {
        guard // validity of email and password checked on server side
            let photo = photo,
            let email = dm[SignUpItem.email],
            let password = dm[SignUpItem.password],
            let displayName = dm[SignUpItem.displayName], !displayName.isEmpty
        else {
            delegate.showAlertWith(message: "req_fields") // TODO! localize
            enableButton()
            return
        }
        
        AuthenticationManager().createUser(email: email, password: password, displayName: displayName, photo: photo) {
            delegate.dismiss()
        } onFail: { errorMessage in
            delegate.showAlertWith(message: errorMessage)
            enableButton()
        }
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignUpItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellData = SignUpItem.allCases[indexPath.row]
        switch cellData {
        case .photo:
            guard let cell = ImageTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            var images = [Data]()
            if let image = photo?.data {
                images.append(image)
            }
            
            cell.configureCell(ImageCellDM(title: cellData.text,
                                           images: images,
                                           maxImages: 1))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .email, .displayName, .password:
            guard let cell = TextFieldTableCell.createCell(tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(TextFieldCellDM(inputType: cellData.type,
                                               title: cellData.text,
                                               detail: dm[cellData] ?? "",
                                               returnKeyType: .done))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        }
    }
    
    // MARK: - ImageCellDelegate
    mutating func newImage(_ data: Data) {
        photo = SaleItemImage(id: UUID().uuidString, data: data)
    }
    
    mutating func deleteImage(at index: Int) {
        photo = nil
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[SignUpItem.allCases[indexPath.row]] = data
    }
}
