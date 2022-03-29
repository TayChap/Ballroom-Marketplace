//
//  LocalizedString.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-01.
//

import Foundation

struct LocalizedString {
    static func string(_ key: String, _ comment: String = "") -> String {
        NSLocalizedString(key, comment: comment)
    }
}
