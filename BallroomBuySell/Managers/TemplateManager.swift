//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

struct TemplateManager {
    private static var imageURLPrefix: String {
        "\(Environment.current.rawValue)/templates/"
    }
    
    // MARK: - Public Helpers
    static func refreshTemplates(_ completion: @escaping (_ templates: [SaleItemTemplate]) -> Void) {
        DatabaseManager.sharedInstance.getTemplates { templates in
            completion(templates)
        }
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account and not in release mode
    static func updateTemplates() {
        // TODO! add DEBUG flag here (not for release) // Firebase does not recommend deleting whole collections from mobile client
        DatabaseManager.sharedInstance.stagingDeleteAllDocuments(in: .templates) {
            let templates = [
                getTailsuitTemplate(),
                getStandardDressTemplate(),
                getLatinDressTemplate(),
                getMensLatinTop(),
                getMensLatinBottom(),
                getMensPracticeTop(),
                getWomansPracticeTop(),
                getWomansPracticeBottom(),
                getWomansStandardShoesTemplate(),
                getWomansLatinShoesTemplate(),
                getMensStandardShoesTemplate(),
                getMensLatinShoesTemplate()]
            for template in templates {
                DatabaseManager.sharedInstance.createDocument(.templates, template)
            }
        }
    }
    
    // MARK: - Private Methods
    private static func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "tailsuit_key",
                         imageURL: "\(imageURLPrefix)tailsuit",
                         screenStructure: [SaleItemCellStructure(type: .picker,
                                                                 inputType: .standard,
                                                                 serverKey: "picker",
                                                                 title: "picker test_title",
                                                                 subtitle: "",
                                                                 placeholder: "",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")]),
                                           SaleItemCellStructure(type: .textField,
                                                                 inputType: .standard,
                                                                 serverKey: "text",
                                                                 title: "text test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 filterEnabled: false)] +
                         Sizing.tails.measurementCells)
    }
    
    private static func getStandardDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "standardDress",
                         name: "standardDress",
                         imageURL: "\(imageURLPrefix)standardDress",
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getLatinDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "latinDress",
                         name: "latinDress",
                         imageURL: "\(imageURLPrefix)latinDress",
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getMensLatinTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinTop",
                         name: "mensLatinTop",
                         imageURL: "\(imageURLPrefix)mensLatinTop",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getMensLatinBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinBottom",
                         name: "mensLatinBottom",
                         imageURL: "\(imageURLPrefix)mensLatinBottom",
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getMensPracticeTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensPracticeTop",
                         name: "mensPracticeTop",
                         imageURL: "\(imageURLPrefix)mensPracticeTop",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeTop",
                         name: "womansPracticeTop",
                         imageURL: "\(imageURLPrefix)womansPracticeTop",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeBottom",
                         name: "womansPracticeBottom",
                         imageURL: "\(imageURLPrefix)womansPracticeBottom",
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getMensStandardShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensStandardShoes",
                         name: "mensStandardShoes shoes_key",
                         imageURL: "\(imageURLPrefix)mensStandardShoes",
                         screenStructure: Sizing.mensFlatShoes.measurementCells)
    }
    
    private static func getMensLatinShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinShoes",
                         name: "mensLatinShoes shoes_key",
                         imageURL: "\(imageURLPrefix)mensLatinShoes",
                         screenStructure: Sizing.mensHeelShoes.measurementCells)
    }
    
    private static func getWomansStandardShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansStandardShoes",
                         name: "WomansStandardShoes shoes_key",
                         imageURL: "\(imageURLPrefix)womansStandardShoes",
                         screenStructure: Sizing.womansHeelShoes.measurementCells)
    }
    
    private static func getWomansLatinShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womanLatinShoes",
                         name: "womanLatinShoes shoes_key",
                         imageURL: "\(imageURLPrefix)womanLatinShoes",
                         screenStructure: Sizing.womansHeelShoes.measurementCells)
    }
}
