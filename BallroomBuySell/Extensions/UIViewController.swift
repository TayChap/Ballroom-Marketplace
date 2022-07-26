//
//  UIViewController.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-20.
//

import UIKit

extension UIViewController {
    // MARK: - IB Methods
    static func getVC<T>(from storyboard: Storyboard, of type: T.Type) -> T {
        UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    // MARK: - Alert Methods
    func showNetworkError(_ error: Error? = nil) { // TODO! remove default nil
        showAlertWith(title: LocalizedString.string("alert.network.title"), message: (error as? NetworkError)?.errorMessage ?? "")
    }
    
    func showAlertWith(title: String? = "", message: String, alertActions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertActions = alertActions {
            for action in alertActions {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: LocalizedString.string("generic.close"), style: .default, handler: nil))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheetOrPopover(title: String? = nil, message: String, alertActions: [UIAlertAction], barButtonItem: UIBarButtonItem? = nil) {
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
