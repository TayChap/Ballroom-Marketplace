//
//  PermissionsManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import AVFoundation
import Photos
import ContactsUI

struct PermissionManager {
    enum PermissionsType {
        case camera, photos
        
        var permissionsRequestString: String {
            String(format: LocalizedString.string("permissions.request"), LocalizedString.string(self.appStringKey))
        }
        
        private var appStringKey: String {
                switch self {
                case .camera: return "apple.camera.app"
                case .photos: return "apple.photos.app"
                }
        }
    }
    
    static func checkCameraPermissions(owner: UIViewController?, _ completion: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion()
        case .denied, .restricted:
            PermissionManager.showAlert(owner, withMessage: PermissionsType.camera.permissionsRequestString)
        default:
            AVCaptureDevice.requestAccess(for: .video) { (hasAccess) in
                if !hasAccess {
                    PermissionManager.showAlert(owner, withMessage: PermissionsType.camera.permissionsRequestString)
                } else {
                    completion()
                }
            }
        }
    }
    
    static func checkPhotosPermissions(owner: UIViewController?, _ completion: @escaping () -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion()
        case .denied, .restricted:
            PermissionManager.showAlert(owner, withMessage: PermissionsType.photos.permissionsRequestString)
        default:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    completion()
                default:
                    PermissionManager.showAlert(owner, withMessage: PermissionsType.photos.permissionsRequestString)
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    private static func showAlert(_ vc: UIViewController?, withMessage message: String) {
        let cancel = UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .default, handler: nil)
        let setting = UIAlertAction(title: LocalizedString.string("apple.settings.app"), style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [.universalLinksOnly : false], completionHandler: nil)
            }
        }
        
        DispatchQueue.main.async {
            vc?.showAlertWith(message: message, alertActions: [cancel, setting])
        }
    }
}
