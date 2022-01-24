//
//  SaleItemTemplate.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemTemplate: Codable {
    var id: String // human readable
    var name: String
    var screenStructure: [SaleItemCellStructure]
    
    static var serverKey: String {
        "templateId"
    }
    
    // MARK: - Public Helpers
    static func getSaleItemHeader(_ templates: [SaleItemTemplate]) -> [SaleItemCellStructure] {
        [SaleItemCellStructure(type: .picker,
                               inputType: .standard,
                               serverKey: SaleItemTemplate.serverKey,
                               title: "template_selector_title",
                               subtitle: "",
                               placeholder: "",
                               required: true,
                               values: templates.map({ PickerValue(serverKey: $0.id, localizationKey: $0.name) })),
         SaleItemCellStructure(type: .imageCollection,
                               inputType: InputType.standard,
                               serverKey: "",
                               title: "image test_title",
                               subtitle: "",
                               placeholder: "",
                               required: true,
                               values: [])]
    }
}
