//
//  UIButton.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .disabled)
    }
}
