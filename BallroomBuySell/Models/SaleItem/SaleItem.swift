//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Storable, Reportable {
    enum QueryKeys: String {
        case id, dateAdded, userId, images
    }
    
    var id = UUID().uuidString
    var dateAdded = Date()
    var userId: String
    var images = [Image]()
    var useStandardSizing = false
    var fields: [String: String] = [:] // [serverKey: value]
    
    func getFilterFields(basedOn template: SaleItemTemplate) -> [String: String] {
        var finalFields = [String: String]()
        let templateScreenStructure = SaleItemTemplate.getScreenStructure(with: [], for: template)
        
        let fields = fields.filter({ field in
            templateScreenStructure.first(where: { $0.serverKey == field.key })?.filterEnabled == true
        })
        
        let measurements = templateScreenStructure.filter({ $0.inputType == .measurement })
        for field in fields {
            guard let templateEntry = templateScreenStructure.first(where: { $0.serverKey == field.key }) else {
                continue // field not in template
            }
            
            if templateEntry.inputType != .standardSize && !measurements.isEmpty {
                finalFields[field.key] = field.value
                continue
            }
            
            // for standard size field, add set of available measurement conversions to fields
            for measurement in measurements {
                guard
                    let standardSize = Sizing.StandardSize(rawValue: field.value),
                    let measurementConversion = measurement.measurements?[standardSize]
                else {
                    continue
                }
                
                finalFields[measurement.serverKey] = String(measurementConversion)
            }
        }
        
        return finalFields
    }
}
