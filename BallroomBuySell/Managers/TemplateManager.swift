//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

/// TODO! describe purpose of class and meaning of word Template
struct TemplateManager { // TODO! update to shared instance singleton
    static var templates = [SaleItemTemplate]()
    
    static func refreshTemplates(_ completion: @escaping () -> Void) {
        DatabaseManager().getDocuments(in: .templates, of: SaleItemTemplate.self) { templates in
            TemplateManager.templates = templates
            completion()
        }
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account and not in release mode
    func updateTemplates() {
        // TODO! add DEBUG flag here (not for release) // Firebase does not recommend deleting whole collections from mobile client
        DatabaseManager().deleteDocuments(in: .templates) {
            let templates = [getTailsuitTemplate()]
            for template in templates {
                DatabaseManager().createDocument(.templates, template)
            }
        }
    }
    
    // MARK: - Private Methods
    private func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "tailsuit_key",
                         screenStructure: [SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "picker",
                                                                 title: "picker test_title",
                                                                 subtitle: "",
                                                                 placeholder: "",
                                                                 required: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")]),
                                           SaleItemCellStructure(type: .textField,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "text",
                                                                 title: "text test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 values: []),
                                           SaleItemCellStructure(type: .imageCollection,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "image",
                                                                 title: "image test_title",
                                                                 subtitle: "",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 values: [])])
    }
}
