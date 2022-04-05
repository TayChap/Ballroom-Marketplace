//
//  UIView.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-29.
//

import UIKit

extension UIView {
    func addBorder(of width: Double, with color: CGColor, cornerRadius: Double = 0) {
        layer.borderWidth = width
        layer.borderColor = color
        roundViewCorners(cornerRadius)
    }
    
    func roundViewCorners(_ radius: Double) {
        layer.cornerRadius = radius
    }
}
