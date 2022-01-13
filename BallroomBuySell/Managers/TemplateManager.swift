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
    func updateTemplates() {
        // TODO! remove all templates, then add them all back (WAY more safe)
        
        let template = getTailsuitTemplate() // update for submission
        DatabaseManager().createDocument(templatesCollectionName, template)
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
