//
//  UICollectionViewCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-27.
//

import UIKit

extension UICollectionViewCell {
    static var defaultRegister: String { "default" }
    
    func applyRoundedCorners() {
        contentView.layer.cornerRadius = 20.0
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 20.0
        layer.masksToBounds = false
    }
}
