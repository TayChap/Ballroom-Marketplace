//
//  NavigationController.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        modalPresentationStyle = .fullScreen
        navigationBar.isTranslucent = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Helpers
    static func hideNavigationBar(_ owner: UIViewController?) {
        owner?.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    static func showNavigationBar(_ owner: UIViewController?) {
        owner?.navigationController?.navigationBar.backgroundColor = Theme.Color.background.value
    }
}

