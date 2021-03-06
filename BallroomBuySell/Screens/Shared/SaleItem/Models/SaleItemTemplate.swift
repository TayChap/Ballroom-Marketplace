//
//  SaleItemTemplate.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemTemplate: Storable {
    enum serverKey: String {
        case templateId, price
    }
    
    let id: String // human readable
    let name: String
    let imageURL: String
    let order: Int
    var screenStructure: [SaleItemCellStructure]
    
    // MARK: - Public Helpers
    static func getItemTitle(by typeId: String, in templates: [SaleItemTemplate]) -> String {
        LocalizedString.string(templates.first(where: { $0.id == typeId })?.name ?? "")
    }
    
    static func getScreenStructure(with templates: [SaleItemTemplate], for selectedTemplate: SaleItemTemplate?) -> [SaleItemCellStructure] {
        getHeaderCells(templates) + (selectedTemplate?.screenStructure ?? []) + getFooterCells()
    }
    
    private static func getHeaderCells(_ templates: [SaleItemTemplate]) -> [SaleItemCellStructure] {
        [getTemplateSelectorCell(templates), getPriceCell(), getLocationCell(), getImageCollectionCelll()]
    }
    
    private static func getFooterCells() -> [SaleItemCellStructure] {
        [getNotesCell()]
    }
    
    private static func getTemplateSelectorCell(_ templates: [SaleItemTemplate]) -> SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .standard,
                              serverKey: SaleItemTemplate.serverKey.templateId.rawValue,
                              titleKey: "generic.category",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: true,
                              filterEnabled: false,
                              values: templates.map({ PickerValue(serverKey: $0.id, localizationKey: $0.name) }))
    }
    
    private static func getPriceCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .textField,
                              inputType: .numbers,
                              serverKey: SaleItemTemplate.serverKey.price.rawValue,
                              titleKey: "sale.item.price",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: true,
                              filterEnabled: false,
                              values: [])
    }
    
    private static func getLocationCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .country,
                              serverKey: "location",
                              titleKey: "generic.location",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: true,
                              filterEnabled: true,
                              values: [])
    }
    
    private static func getImageCollectionCelll() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .imageCollection,
                              inputType: .standard,
                              serverKey: SaleItem.QueryKeys.images.rawValue,
                              titleKey: "sale.item.images",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: true,
                              filterEnabled: false,
                              values: [])
    }
    
    private static func getNotesCell() -> SaleItemCellStructure {
        SaleItemCellStructure(type: .textView,
                              inputType: .standard,
                              serverKey: "notes",
                              titleKey: "generic.notes",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: false,
                              values: [])
    }
}
