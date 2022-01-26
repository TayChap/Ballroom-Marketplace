//
//  SaleItemFilterVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-24.
//

import UIKit

class SaleItemFilterVC: UIViewController, ViewControllerProtocol {
    
    private var vm: SaleItemFilterVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController() -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = SaleItemFilterVM()
        
        return vc
    }
}
