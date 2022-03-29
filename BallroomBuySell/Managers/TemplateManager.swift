//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

struct TemplateManager {
    private static var imageURLPrefix: String {
        "\(Environment.current.rawValue)/templates/ballroom/"
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
                // Competition
                getTailsuitTemplate(),
                getStandardDressTemplate(),
                getLatinDressTemplate(),
                getMensLatinTop(),
                getMensBottom(),
                // Practice
                getMensPracticeTop(),
                getWomansPracticeTop(),
                getWomansPracticeBottom(),
                // Shoes
                getWomansStandardShoesTemplate(),
                getWomansLatinShoesTemplate(),
                getMensStandardShoesTemplate(),
                getMensLatinShoesTemplate()
            ]
            for template in templates {
                DatabaseManager.sharedInstance.createDocument(.templates, template)
            }
        }
    }
    
    // MARK: - Private Methods
    private static func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "sale.item.tailsuit.title",
                         imageURL: "\(imageURLPrefix)tailsuit.jpeg",
                         screenStructure: Sizing.tails.measurementCells)
    }
    
    private static func getStandardDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "standardDress",
                         name: "sale.item.womens.standard.dress.title",
                         imageURL: "\(imageURLPrefix)standardDress.jpeg",
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getLatinDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "latinDress",
                         name: "sale.item.womens.latin.dress.title",
                         imageURL: "\(imageURLPrefix)latinDress.jpeg",
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getMensLatinTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinTop",
                         name: "sale.item.mens.latin.top.title",
                         imageURL: "\(imageURLPrefix)mensLatinTop.jpeg",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getMensBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinBottom",
                         name: "sale.item.mens.latin.bottom.title",
                         imageURL: "\(imageURLPrefix)mensBottom.jpeg",
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getMensPracticeTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensPracticeTop",
                         name: "sale.item.mens.practice.top.title",
                         imageURL: "\(imageURLPrefix)mensPracticeTop.jpeg",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeTop",
                         name: "sale.item.womens.practice.top.title",
                         imageURL: "\(imageURLPrefix)womansPracticeTop.jpeg",
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeBottom",
                         name: "sale.item.womens.practice.bottom.title",
                         imageURL: "\(imageURLPrefix)womansPracticeBottom.jpeg",
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getMensStandardShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensStandardShoes",
                         name: "sale.item.mens.standard.shoes.title",
                         imageURL: "\(imageURLPrefix)mensStandardShoes",
                         screenStructure: Sizing.mensFlatShoes.measurementCells)
    }
    
    private static func getMensLatinShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinShoes",
                         name: "sale.item.mens.latin.shoes.title",
                         imageURL: "\(imageURLPrefix)mensLatinShoes",
                         screenStructure: Sizing.mensHeelShoes.measurementCells)
    }
    
    private static func getWomansStandardShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansStandardShoes",
                         name: "sale.item.womens.standard.shoes.title",
                         imageURL: "\(imageURLPrefix)womansStandardShoes",
                         screenStructure: Sizing.womansHeelShoes.measurementCells)
    }
    
    private static func getWomansLatinShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womanLatinShoes",
                         name: "sale.item.womens.latin.shoes.title",
                         imageURL: "\(imageURLPrefix)womanLatinShoes",
                         screenStructure: Sizing.womansHeelShoes.measurementCells)
    }
}
