//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct BuyVM {
    private weak var delegate: ViewControllerProtocol?
    private var templates: [SaleItemTemplate]?
    var screenStructure = [SaleItem]()
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - IBActions
    func sellButtonClicked() {
        guard let templates = templates else {
            // TODO! network error
            return
        }
        
        guard let _ = AuthenticationManager().user else {
            delegate?.presentViewController(LoginVC.createViewController())
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
        screenStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, _ owner: UIViewController) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, _ viewController: ViewControllerProtocol) {
        // TODO! refactor when switch to modern collection view
//        var cellData = screenStructure[indexPath.row]
//        let url = cellData.images.first?.url ?? ""
//        ImageManager.sharedInstance.downloadImage(at: url) { data in
//            cellData.images.insert(Image(url: url, data: data), at: 0)
//            delegate?.pushViewController(ViewItemVC.createViewController(cellData))
//        }
        
        guard let templates = templates else  {
            return
        }
        
        // TODO! need to pass in some sort of filter item
        delegate?.pushViewController(SaleItemListVC.createViewController(templates, screenStructure))
    }
    
    // Public Helpers
    mutating func onTemplatesFetched(_ templates: [SaleItemTemplate]) {
        self.templates = templates
    }
}
