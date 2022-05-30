//
//  ProfileVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

struct ProfileVM {
    enum ProfileItem: CaseIterable {
        case photo
        case email
        case displayName
        
        var textKey: String {
            switch self {
            case .photo: return "user.profile.photo"
            case .email: return "generic.email"
            case .displayName: return "user.display.name"
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
    
    weak private var delegate: ViewControllerProtocol?
    private var user: User
    private var photo: Image?
    
    // MARK: - Lifecycle Methods
    init(user: User, photo: Image?, delegate: ViewControllerProtocol) {
        self.user = user
        self.photo = photo
        self.delegate = delegate
    }
    
    func viewDidLoad(with tableView: UITableView) {
        ImageTableCell.registerCell(for: tableView)
        TextFieldTableCell.registerCell(for: tableView)
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        delegate?.dismiss()
    }
    
    func updateUserButtonClicked() {
        guard let photo = photo, !user.displayName.isEmpty else {
            delegate?.showAlertWith(message: LocalizedString.string("alert.required.fields.message"))
            return
        }
        
        if user.email?.isValidEmail() != true {
            delegate?.showAlertWith(message: LocalizedString.string("alert.invalid.email"))
        }
        
        AuthenticationManager.sharedInstance.updateUser(user, with: photo) {
            delegate?.showAlertWith(message: LocalizedString.string("generic.success"))
        } onFail: {
            delegate?.showNetworkError()
        }
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProfileItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        let cellData = ProfileItem.allCases[indexPath.row]
        switch cellData {
        case .photo:
            guard let cell = ImageTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            var images = [Data]()
            if let image = photo?.data {
                images.append(image)
            }
            
            cell.configureCell(with: ImageCellDM(title: LocalizedString.string(cellData.textKey),
                                                 images: images,
                                                 maxImages: 1))
            cell.delegate = owner as? (ImageCellDelegate & UIViewController)
            return cell
        case .email, .displayName:
            guard let cell = TextFieldTableCell.createCell(for: tableView) else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: TextFieldCellDM(inputType: cellData.type,
                                                     title: LocalizedString.string(cellData.textKey),
                                                     detail: cellData == .email ? user.email ?? "" : user.displayName,
                                                     returnKeyType: .done))
            cell.delegate = owner as? TextFieldCellDelegate
            return cell
        }
    }
    
    // MARK: - ImageCellDelegate
    mutating func newImage(_ data: Data) {
        photo = Image(for: .user, data: data)
        user.photoURL = photo?.url
    }
    
    mutating func deleteImage(at index: Int) {
        photo = nil
    }
    
    // MARK: - Public Helpers
    mutating func setData(_ data: String, at indexPath: IndexPath) {
        let cellData = ProfileItem.allCases[indexPath.row]
        switch cellData {
        case .email:
            user.email = data
        case .displayName:
            user.displayName = data
        default:
            break // profile image handled separately
        }
    }
}
