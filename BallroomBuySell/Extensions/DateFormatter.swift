//
//  DateFormatter.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import Foundation

extension DateFormatter {
    static func withFormat(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter
    }
}
