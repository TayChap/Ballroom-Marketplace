//
//  String.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-30.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    private var requiredIndicator: String {
        "*"
    }
    
    func attributedText(color: UIColor, required: Bool = false) -> NSMutableAttributedString {
        let text = required ? "\(self) \(requiredIndicator)" : self
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
        if required {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.Color.error.value, range: (text as NSString).range(of: requiredIndicator))
        }
        
        return attributedText
    }
}
