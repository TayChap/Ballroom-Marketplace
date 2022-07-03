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
    
    static func getCountryName(_ countryCode: String?) -> String? {
        guard let countryCode = countryCode else {
            return nil
        }
        
        return Locale.current.localizedString(forRegionCode: countryCode)
    }
}
