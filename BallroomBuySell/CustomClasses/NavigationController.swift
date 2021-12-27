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
        navigationBar.isTranslucent = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

