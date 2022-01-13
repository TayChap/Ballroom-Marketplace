//
//  StoryboardManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

struct StoryboardManager {
    enum Storyboard: String {
        case main = "Main"
        case authentication = "Authentication"
    }
    
    // MARK: - Public Helpers
    func getVC<T: ViewControllerProtocol>(from storyboard: Storyboard, of type: T.Type) -> T? {
        UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
