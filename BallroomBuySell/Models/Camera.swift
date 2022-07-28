//
//  MediaManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-11.
//

import UIKit

struct Camera {
    static func displayCamera(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, displayingVC: UIViewController?) {
        let controller = UIImagePickerController()
        controller.delegate = delegate
        controller.sourceType = .camera
        controller.modalPresentationStyle = .fullScreen
        PermissionManager.checkCameraPermissions(owner: displayingVC) {
            DispatchQueue.main.async {
                displayingVC?.present(controller, animated: true)
            }
        }
    }
}
