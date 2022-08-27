//
//  UIButton.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String, with color: UIColor? = nil) {
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .disabled)
        
        guard let color = color else {
            return
        }
        
        setTitleColor(color, for: .normal)
    }
}
