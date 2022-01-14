//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

class BuyVM { // TODO! revisit to change to struct
    private weak var delegate: ViewControllerProtocol?
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        TemplateManager.refreshTemplates()
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard let _ = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        if TemplateManager.templates.isEmpty {
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController())
    }
    
    func profileButtonClicked() {
        guard let user = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        delegate?.pushViewController(ProfileVC.createViewController(user))
    }
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        // TODO!
    }
    
    // MARK: - Private Helpers
}
