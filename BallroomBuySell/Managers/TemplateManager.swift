//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

/// TODO! describe purpose of class and meaning of word Template
struct TemplateManager {
    private static let templatesCollectionName = "templates"
    static var templates = [SaleItemTemplate]()
    
    static func refreshTemplates() {
        DatabaseManager().getDocuments(in: templatesCollectionName, of: SaleItemTemplate.self) { templates in
            if let templates = templates {
                TemplateManager.templates = templates
            }
        }
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account and not in release mode
    func updateTemplates() {
        // TODO! add DEBUG flag here (not for release) // Firebase does not recommend deleting whole collections from mobile client
        DatabaseManager().deleteDocuments(in: TemplateManager.templatesCollectionName) {
            let templates = [getTailsuitTemplate()]
            for template in templates {
                DatabaseManager().createDocument(TemplateManager.templatesCollectionName, template)
            }
        }
    }
    
    // MARK: - Private Methods
    private func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "tailsuit_key",
                         screenStructure: [SaleItemCellStructure(type: .textField,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "test",
                                                                 title: "test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")])])
    }
}
