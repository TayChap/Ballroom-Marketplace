//
//  ViewControllerProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {
    func pushViewController(_ vc: UIViewController)
    func presentViewController(_ vc: UIViewController)
    func dismiss()
    func reload()
}

extension ViewControllerProtocol { // TODO! remove at least some extensions where possible
    func pushViewController(_ vc: UIViewController) {}
    func presentViewController(_ vc: UIViewController) {}
    func dismiss() {}
    func reload() {}
}
