//
//  PermissionsManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit
import AVFoundation

struct PermissionManager {
    enum PermissionsType {
        case camera
        
        var permissionsRequestString: String {
            String(format: LocalizedString.string("permissions.request"), LocalizedString.string(self.appStringKey))
        }
        
        private var appStringKey: String {
                switch self {
                case .camera: return "apple.camera.app"
                }
        }
    }
    
    static func checkCameraPermissions(owner: UIViewController?, _ completion: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            completion()
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { hasAccess in
                if !hasAccess {
                    PermissionManager.showAlert(owner, withMessage: PermissionsType.camera.permissionsRequestString)
                } else {
                    completion()
                }
            }
        default: // case .denied, .restricted
            PermissionManager.showAlert(owner, withMessage: PermissionsType.camera.permissionsRequestString)
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
