//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

/// TODO! describe purpose of class and meaning of word Template
struct TemplateManager {
    private let templatesCollectionName = "templates"
    
    func refreshTemplates(_ completion: @escaping ([SaleItemTemplate]?) -> Void) {
        DatabaseManager().getDocuments(in: templatesCollectionName, of: SaleItemTemplate.self) { templates in
            completion(templates)
        }
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account
    func addTemplate() {
        let template = getTailsuitTemplate() // update for submission
        DatabaseManager().createDocument(templatesCollectionName, template.name, template.template)
    }
    
    private func getTailsuitTemplate() -> (name: String, template: SaleItemTemplate) {
        ("Tailsuit",
         SaleItemTemplate(name: "shoes2",
                          cellStructure: [SaleItemCellStructure(title: "hello",
                                                                subtitle: "so subtitle")]))
    }
}
