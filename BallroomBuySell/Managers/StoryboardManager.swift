//
//  StoryboardManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

struct StoryboardManager {
    func getMain() -> UIStoryboard {
        getStoryboard("Main")
    }
    
    func getAuthentication() -> UIStoryboard {
        getStoryboard("Authentication")
    }
    
    private func getStoryboard(_ storyboardName: String) -> UIStoryboard{
        UIStoryboard(name: storyboardName, bundle: nil)
    }
}
