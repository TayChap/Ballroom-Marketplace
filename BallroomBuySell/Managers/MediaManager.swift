//
//  MediaManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-11.
//

import UIKit

struct MediaManager {
    static func displayCamera(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, displayingVC: UIViewController?) {
        let controller = UIImagePickerController()
        controller.delegate = delegate
        controller.sourceType = .camera
        controller.modalPresentationStyle = .fullScreen
        PermissionManager.checkCameraPermissions(owner: displayingVC) {
            DispatchQueue.main.async {
                displayingVC?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    static func displayGallery(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, displayingVC: UIViewController?) {
        let controller = UIImagePickerController()
        controller.delegate = delegate
        controller.sourceType = .photoLibrary
        controller.modalPresentationStyle = .fullScreen
        PermissionManager.checkPhotosPermissions(owner: displayingVC) {
            DispatchQueue.main.async {
                displayingVC?.present(controller, animated: true, completion: nil)
            }
        }
    }
}
