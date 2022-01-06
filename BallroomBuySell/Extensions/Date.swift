//
//  Date.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//

import Foundation

extension Date {
    func toReadableString() -> String {
        DateFormatter.withFormat("MMM d, yyyy").string(from: self)
    }
    
    static func toDateFromReadableString(dateString: String) -> Date? {
        DateFormatter.withFormat("MMM d, yyyy").date(from: dateString)
    }
}
