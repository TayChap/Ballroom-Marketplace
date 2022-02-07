//
//  InputType.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-13.
//

import UIKit

enum InputType: String, Codable {
    case standard, password, email
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .standard, .password: return .default
        case .email: return .emailAddress
        }
    }
    
    var autoCapitalization: UITextAutocapitalizationType {
        switch self {
        case .password, .email: return .none
        default: return .sentences
        }
    }
    
    var autocorrectionType: UITextAutocorrectionType {
        switch self {
        case .password, .email: return .no
        default: return .yes
        }
    }
}
