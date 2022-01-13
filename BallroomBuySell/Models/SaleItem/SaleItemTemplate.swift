//
//  SaleItemTemplate.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemTemplate: Codable {
    var id: String // human readable
    var name: String
    //var previewCellStructure: [SaleItemPreviewCellStructure]
    var screenStructure: [SaleItemCellStructure]
    
    // MARK: - Public Helpers
    static func getTemplateSelectorItem(_ templates: [SaleItemTemplate]) -> SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .standard,
                              serverKey: "",
                              title: "",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              values: templates.map({ PickerValue(serverKey: $0.id, localizationKey: $0.name) }))
    }
}
