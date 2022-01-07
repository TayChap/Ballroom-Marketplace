//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct BuyVM {
    private weak var delegate: ViewControllerProtocol?
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController(user))
    }
    
    func profileButtonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(ProfileVC.createViewController(user))
    }
    
    // MARK: - Private Helpers
}
