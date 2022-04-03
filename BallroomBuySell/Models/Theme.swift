//
//  Theme.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-31.
//

import UIKit

struct Theme {
    enum Color: String {
        // primary
        case primaryText // Text Contrasting with background
        // secondary
        case secondaryText // Text Contrasting with cardBackground
        // tertiary
        case background, cardBackground, confirmation, divider, error, interactivity
        
        var value: UIColor {
            UIColor(named: self.rawValue) ?? .black
        }
    }
    
    static func initializeAppTheme() {
        UINavigationBar.appearance().backgroundColor = Color.background.value
        UINavigationBar.appearance().barTintColor = Color.background.value
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.primaryText.value]
    }
}
