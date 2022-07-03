//
//  Environment.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-06.
//

enum Environment: String {
    case staging, marketing, production
    
    static var current: Environment {
        staging
    }
}
