//
//  SaleItemTemplate.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemTemplate: Codable {
    let id: String // human readable
    let name: String
    let imageURL: String
    var screenStructure: [SaleItemCellStructure]
    
    static var serverKey: String {
        "templateId"
    }
    
    // MARK: - Public Helpers
    static func getHeaderCells(_ templates: [SaleItemTemplate]) -> [SaleItemCellStructure] {
        [getTemplateSelectorCell(templates), getPriceCell(), getLocationCell(), getImageCollectionCelll()]
    }
    
    static func getFooterCells() -> [SaleItemCellStructure] {
        [getNotesCell()]
    }
    
    private static func getTemplateSelectorCell(_ templates: [SaleItemTemplate]) -> SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .standard,
                              serverKey: SaleItemTemplate.serverKey,
                              title: "template_selector_title",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: true,
                              values: templates.map({ PickerValue(serverKey: $0.id, localizationKey: $0.name) }))
    }
    
    private static func getPriceCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .textField,
                              inputType: .numbers,
                              serverKey: "price",
                              title: "price (USD)",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: true,
                              values: [])
    }
    
    private static func getLocationCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .country,
                              serverKey: "location",
                              title: "_location_",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: true,
                              values: [])
    }
    
    private static func getImageCollectionCelll() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .imageCollection,
                              inputType: .standard,
                              serverKey: "",
                              title: "image test_title",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: false,
                              values: [])
    }
    
    private static func getNotesCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .textView,
                              inputType: .standard,
                              serverKey: "notes",
                              title: "_notes_",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: true,
                              values: [])
    }
    
    static func getContactSellerCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .button,
                              inputType: .standard,
                              serverKey: "",
                              title: "contact_seller",
                              subtitle: "",
                              placeholder: "",
                              required: false,
                              filterEnabled: false,
                              values: [])
    }
}
