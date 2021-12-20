//
//  UIViewController.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-20.
//

import UIKit

extension UIViewController {
    func showAlertWith(title: String? = "", message: String, alertActions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertActions = alertActions {
            for action in alertActions {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: NSLocalizedString("generic.close", comment: "Closes alert"), style: .default, handler: nil))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheetOrPopover(_ title: String?, _ message: String, _ alertActions: [UIAlertAction], _ barButtonItem: UIBarButtonItem? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in alertActions {
            alert.addAction(action)
        }
        
        if let barButtonItem = barButtonItem {
            alert.popoverPresentationController?.barButtonItem = barButtonItem
        } else {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
}
