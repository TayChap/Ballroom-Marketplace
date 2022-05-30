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

extension ViewControllerProtocol {
    func pushViewController(_ vc: UIViewController) {}
    func presentViewController(_ vc: UIViewController) {}
    func dismiss() {}
    func reload() {}
}
