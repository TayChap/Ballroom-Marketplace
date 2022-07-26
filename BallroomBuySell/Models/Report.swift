//
//  Report.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-04-25.
//

import UIKit

struct Report<Item: Storable & Reportable>: Storable {
    var id = UUID().uuidString
    let reason: String
    let item: Item
    let reportedUserId: String
    let reportingUserId: String
    var date = Date()
    
    static func submitReport(for item: Item,
                             with reason: String,
                             delegate: UIViewController?,
                             reportingUser: User) {
        let alertController = UIAlertController(title: LocalizedString.string("report.reason.title"), message: LocalizedString.string("report.reason"), preferredStyle: .alert)
        let cancel = UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel)
        let report = UIAlertAction(title: LocalizedString.string("generic.report"), style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                return
            }
            
            do {
                try DatabaseManager.sharedInstance.putDocument(in: .reports,
                                                               for: Report(reason: textField.text ?? "",
                                                                           item: item,
                                                                           reportedUserId: item.reportableUserId,
                                                                           reportingUserId: reportingUser.id))
                AuthenticationManager.sharedInstance.blockUser(item.reportableUserId)
                
                // TODO! refactor - put updated user on server
                guard let user = AuthenticationManager.sharedInstance.user else {
                    return
                }
                
                try DatabaseManager.sharedInstance.putDocument(in: .users,
                                                               for: user)
                delegate?.showAlertWith(message: LocalizedString.string("generic.success"))
            } catch {
                delegate?.showNetworkError()
            }
        }
        
        alertController.addTextField()
        alertController.addAction(cancel)
        alertController.addAction(report)
        delegate?.present(alertController, animated: true, completion: nil)
    }
}
