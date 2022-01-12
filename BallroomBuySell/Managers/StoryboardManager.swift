//
//  StoryboardManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-21.
//

import UIKit

struct StoryboardManager { // TODO! this is not really a "manager" since it doesn't do anything to the SB
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
