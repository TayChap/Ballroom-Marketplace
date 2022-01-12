//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

class BuyVM { // TODO! revisit to change to struct
    private weak var delegate: ViewControllerProtocol?
    private var templates: [SaleItemTemplate]?
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func viewDidLoad(_ tableView: UITableView) {
        TemplateManager().refreshTemplates { templates in
            self.templates = templates
        }
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard let _ = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
            return
        }
        
        guard let templates = templates else {
            // TODO! present network error message
            return
        }
        
        delegate?.pushViewController(SellVC.createViewController(templates))
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
