//
//  Environment.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-02-06.
//

enum Environment: String {
    case staging, production
    
    static var current: Environment {
        production
    }
}
