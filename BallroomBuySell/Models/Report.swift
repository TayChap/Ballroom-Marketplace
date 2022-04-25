//
//  Report.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-04-25.
//

import UIKit

struct Report<Item: Codable>: Codable {
    let reason: String
    let item: Item
    var date = Date()
    
    static func submitReport(for item: Item, with reason: String, delegate: UIViewController?) {
        let alertController = UIAlertController(title: "", message: LocalizedString.string("report.reason"), preferredStyle: .alert)
        let cancel = UIAlertAction(title: LocalizedString.string("generic.cancel"), style: .cancel)
        let report = UIAlertAction(title: LocalizedString.string("generic.report"), style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                return
            }
            
            DatabaseManager.sharedInstance.createDocument(in: .reports, for: Report(reason: textField.text ?? "", item: item)) {
                delegate?.showAlertWith(message: LocalizedString.string(""))
            } onFail: {
                delegate?.showNetworkError()
            }
        }
        
        alertController.addTextField()
        alertController.addAction(cancel)
        alertController.addAction(report)
        delegate?.present(alertController, animated: true, completion: nil)
    }
}
