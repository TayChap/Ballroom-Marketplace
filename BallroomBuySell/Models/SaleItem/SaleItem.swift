//
//  SaleItem.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

import Foundation

struct SaleItem: Codable {
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
        let measurements = template.screenStructure.filter({ $0.inputType == .measurement })
        var finalFields = [String: String]()
        
        for field in fields.filter({ _ in template.screenStructure.contains(where: { $0.filterEnabled }) }) {
            guard let templateEntry = template.screenStructure.first(where: { $0.serverKey == field.key }) else {
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
