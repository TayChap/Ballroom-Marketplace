//
//  ViewControllerProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {
    static func createViewController() -> UIViewController
    func pushViewController(_ vc: UIViewController)
    func presentViewController(_ vc: UIViewController)
    func dismiss()
    func reload()
}

extension ViewControllerProtocol {
    static func createViewController() -> UIViewController { UIViewController() }
    func pushViewController(_ vc: UIViewController) {}
    func presentViewController(_ vc: UIViewController) {}
    func dismiss() {}
    func reload() {}
}
