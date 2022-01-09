//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

struct TemplateManager {
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account
    func addTemplate() {
        let template = getTailsuitTemplate()
        DatabaseManager().createDocument("templates", template.name, template.template)
    }
    
    private func getTailsuitTemplate() -> (name: String, template: SaleItemTemplate) {
        ("Tailsuit",
         SaleItemTemplate(name: "shoes2",
                          cellStructure: [SaleItemCellStructure(title: "hello",
                                                                subtitle: "so subtitle")]))
    }
}
