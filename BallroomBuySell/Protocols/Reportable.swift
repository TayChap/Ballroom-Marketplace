//
//  Reportable.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-05-08.
//

protocol Reportable {
    var reportableUserId: String { get }
}

extension Reportable {
    func isAcceptable() -> Bool {
        !(AuthenticationManager.sharedInstance.user?.blockedUserIds.contains(reportableUserId) ?? false)
    }
}
