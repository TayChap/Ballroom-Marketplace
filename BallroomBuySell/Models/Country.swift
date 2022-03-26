//
//  Country.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-26.
//

import Foundation

struct Country {
    let code: String
    let localizedString: String
    
    static var getCountryPickerValues: [Country] {
        Locale.isoRegionCodes.compactMap({ Country(code: $0, localizedString: Locale.current.localizedString(forRegionCode: $0) ?? "") })
    }
}
