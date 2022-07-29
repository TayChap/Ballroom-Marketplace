//
//  ViewControllerProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

protocol ViewControllerProtocol: UIViewController { // TODO! remove
    func pushViewController(_ vc: UIViewController)
    func presentViewController(_ vc: UIViewController)
    func dismiss()
    func reload()
}

extension ViewControllerProtocol { // TODO! remove
    func pushViewController(_ vc: UIViewController) {}
    func presentViewController(_ vc: UIViewController) {}
    func dismiss() {}
    func reload() {}
}

@MainActor
protocol ViewControllerProtocol2: UIViewController { // TODO! remove
    func pushViewController(_ vc: UIViewController)
    func presentViewController(_ vc: UIViewController)
    func dismiss()
    func reload()
}

extension ViewControllerProtocol2 { // TODO! remove
    func pushViewController(_ vc: UIViewController) {}
    func presentViewController(_ vc: UIViewController) {}
    func dismiss() {}
    func reload() {}
}
