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
        
        var text: String {
            switch self {
            case .photo: return "photo"
            case .email: return "email"
            case .displayName: return "name"
            }
        }
        
        var type: InputType {
            switch self {
            case .email: return .email
            default: return .standard
            }
        }
        
        var returnKeyType: UIReturnKeyType {
            switch self {
            default: return .next
            }
        }
    }
    
    weak var delegate: ViewControllerProtocol?
    private var photo: Image?
    private var dm = [SignUpItem: String]()
    
    // MARK: - Lifecycle Methods
    init(delegate: ViewControllerProtocol) {
        self.delegate = delegate
        for item in SignUpItem.allCases {
            dm[item] = ""
        }
    }
    
    func viewDidLoad(with tableView: UITableView) {
        ImageTableCell.registerCell(for: tableView)
        TextFieldTableCell.registerCell(for: tableView)
    }
    
    // MARK: - IBActions
    func signUpButtonClicked(_ delegate: ViewControllerProtocol) {
        guard // validity of email and password checked on server side
            let photo = photo,
            let email = dm[SignUpItem.email],
            let displayName = dm[SignUpItem.displayName], !displayName.isEmpty
        else {
            delegate.showAlertWith(message: LocalizedString.string("alert.required.fields.message"))
            return
        }
        
        AuthenticationManager().createStagingUser(email: email, displayName: displayName, photo: photo) {
            delegate.dismiss()
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
            guard let cell = ImageTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            var images = [Data]()
            if let image = photo?.data {
                images.append(image)
            }
            
            cell.configureCell(with: ImageCellDM(title: cellData.text,
                                                 images: images,
                                                 maxImages: 1))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .email, .displayName:
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
    }
    
    // MARK: - ImageCellDelegate
    mutating func newImage(_ data: Data) {
        photo = Image(data: data)
    }
    
    mutating func deleteImage(at index: Int) {
        photo = nil
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        dm[SignUpItem.allCases[indexPath.row]] = data
    }
}
