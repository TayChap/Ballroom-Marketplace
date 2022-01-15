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
    static func checkCameraPermissions(owner: UIViewController?, _ completion: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion()
        case .denied, .restricted:
            PermissionManager.showAlert(owner, withMessage: "permissions_camera")
        default:
            AVCaptureDevice.requestAccess(for: .video) { (hasAccess) in
                if !hasAccess {
                    PermissionManager.showAlert(owner, withMessage: "permissions_camera")
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
            PermissionManager.showAlert(owner, withMessage: "permissions_gallery")
        default:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    completion()
                default:
                    PermissionManager.showAlert(owner, withMessage: "permissions_gallery")
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    private static func showAlert(_ vc: UIViewController?, withMessage message: String) {
        let cancel = UIAlertAction(title: "generic.cancel", style: .default, handler: nil)

        let setting = UIAlertAction(title: "navigation.item.settings.title", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [.universalLinksOnly : false], completionHandler: nil)
            }
        }
        
        DispatchQueue.main.async {
            vc?.showAlertWith(message: message, alertActions: [cancel, setting])
        }
    }
}
