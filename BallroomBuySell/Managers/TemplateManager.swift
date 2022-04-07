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
    static func refreshTemplates(_ completion: @escaping (_ templates: [SaleItemTemplate]) -> Void, _ onFail: @escaping () -> Void) {
        DatabaseManager.sharedInstance.getTemplates({ templates in
            completion(templates)
        }, {
            onFail()
        })
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account and not in release mode
    static func updateTemplates() {
        DatabaseManager.sharedInstance.stagingDeleteAllDocuments(in: .templates) {
            let templates = [
                // Competition
//                getTailsuitTemplate(), // TODO!
                getStandardDressTemplate(),
                getLatinDressTemplate(),
                getMensLatinTop(),
                getMensBottom(),
                // Practice
                getMensStandardTop(),
                getWomansPracticeTop(),
                getWomansPracticeBottom(),
                getWomansPracticeDressTemplate(),
                // Shoes
                getWomansShoesTemplate(),
                getMensShoesTemplate(),
                // Misc
                getMiscTemplate()
            ]
            for template in templates {
                DatabaseManager.sharedInstance.createDocument(.templates, template, nil, {}, onFail: {}) // dev only so no handling
            }
        }
    }
    
    // MARK: - Private Methods
    private static func getStandardDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "standardDress",
                         name: "sale.item.womens.standard.dress.title",
                         imageURL: "\(imageURLPrefix)standardDress.jpeg",
                         order: 200,
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getLatinDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "latinDress",
                         name: "sale.item.womens.latin.dress.title",
                         imageURL: "\(imageURLPrefix)latinDress.jpeg",
                         order: 300,
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "sale.item.tailsuit.title",
                         imageURL: "\(imageURLPrefix)tailsuit.jpeg",
                         order: 350,
                         screenStructure: Sizing.tails.measurementCells)
    }
    
    private static func getMensBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinBottom",
                         name: "sale.item.mens.latin.bottom.title",
                         imageURL: "\(imageURLPrefix)mensBottom.jpeg",
                         order: 375,
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getMensLatinTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensLatinTop",
                         name: "sale.item.mens.latin.top.title",
                         imageURL: "\(imageURLPrefix)mensLatinTop.jpeg",
                         order: 400,
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getMensStandardTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensStandardTop",
                         name: "sale.item.mens.standard.top.title",
                         imageURL: "\(imageURLPrefix)mensStandardTop.jpeg",
                         order: 600,
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeTop() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeTop",
                         name: "sale.item.womens.practice.top.title",
                         imageURL: "\(imageURLPrefix)womensPracticeTop.jpeg",
                         order: 700,
                         screenStructure: Sizing.shirt.measurementCells)
    }
    
    private static func getWomansPracticeBottom() -> SaleItemTemplate {
        SaleItemTemplate(id: "womansPracticeBottom",
                         name: "sale.item.womens.practice.bottom.title",
                         imageURL: "\(imageURLPrefix)womensBottom.jpeg",
                         order: 800,
                         screenStructure: Sizing.pant.measurementCells)
    }
    
    private static func getWomansPracticeDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womensPracticeDress",
                         name: "sale.item.womens.practice.dress.title",
                         imageURL: "\(imageURLPrefix)womensPracticeDress.jpeg",
                         order: 850,
                         screenStructure: Sizing.dress.measurementCells)
    }
    
    private static func getMensShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "mensShoes",
                         name: "sale.item.mens.shoes.title",
                         imageURL: "\(imageURLPrefix)mensShoes.jpeg",
                         order: 900,
                         screenStructure: Sizing.mensShoes.measurementCells)
    }
    
    private static func getWomansShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "womensShoes",
                         name: "sale.item.womens.shoes.title",
                         imageURL: "\(imageURLPrefix)womensShoes.jpeg",
                         order: 1100,
                         screenStructure: Sizing.womansShoes.measurementCells)
    }
    
    private static func getMiscTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "misc",
                         name: "sale.item.misc.title",
                         imageURL: "\(imageURLPrefix)misc.jpeg",
                         order: 1200,
                         screenStructure: [])
    }
}
