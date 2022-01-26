//
//  BuyVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import UIKit

struct BuyVM {
    private weak var delegate: ViewControllerProtocol?
    var screenStructure = [SaleItem]()
    
    // MARK: - Lifecycle Methods
    init(_ delegate: ViewControllerProtocol) {
        self.delegate = delegate
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
        
        // TODO! need to pass in some sort of filter item
        delegate?.pushViewController(SaleItemListVC.createViewController(screenStructure))
    }
}
