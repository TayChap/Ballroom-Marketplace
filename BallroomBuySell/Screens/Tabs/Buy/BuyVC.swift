//
//  BuyVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-27.
//

import UIKit

class BuyVC: UIViewController, ViewControllerProtocol {
    // MARK: - Lifecycle Methods
    
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
