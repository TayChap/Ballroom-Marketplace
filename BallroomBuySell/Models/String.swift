//
//  String.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-30.
//

import UIKit

extension String {
    private var requiredIndicator: String {
        "*"
    }
    
    func attributedText(color: UIColor, required: Bool = false) -> NSMutableAttributedString {
        let text = required ? "\(self) \(requiredIndicator)" : self
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
        if required {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: requiredIndicator))
        }
        
        return attributedText
    }
}
