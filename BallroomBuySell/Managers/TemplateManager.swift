//
//  TemplateManager.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-08.
//

/// TODO! describe purpose of class and meaning of word Template
struct TemplateManager {
    // MARK: - Public Helpers
    func refreshTemplates(_ completion: @escaping (_ templates: [SaleItemTemplate]) -> Void) {
        DatabaseManager.sharedInstance.getTemplates { templates in
            completion(templates)
        }
    }
    
    /// This method adds a hardcoded template to the templates collection
    /// The templates collection is only accessible when the app is signed into the superuser account and not in release mode
    func updateTemplates() {
        // TODO! add DEBUG flag here (not for release) // Firebase does not recommend deleting whole collections from mobile client
        DatabaseManager.sharedInstance.deleteDocuments(in: .templates) {
            let templates = [
                getTailsuitTemplate(),
                getShoesTemplate()
            ]
            
            for template in templates {
                DatabaseManager.sharedInstance.createDocument(.templates, template)
            }
        }
    }
    
    // MARK: - Private Methods
    private func getTailsuitTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "tailsuit",
                         name: "tailsuit_key",
                         imageURL: "tailsuit",
                         screenStructure: [SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "picker",
                                                                 title: "picker test_title",
                                                                 subtitle: "",
                                                                 placeholder: "",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")]),
                                           SaleItemCellStructure(type: .textField,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "text",
                                                                 title: "text test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 filterEnabled: false,
                                                                 values: [])])
    }
    
    private func getShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "shoes",
                         name: "shoes_key",
                         imageURL: "shoes",
                         screenStructure: [SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "picker",
                                                                 title: "picker test_title",
                                                                 subtitle: "",
                                                                 placeholder: "",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")]),
                                           SaleItemCellStructure(type: .textField,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "text",
                                                                 title: "text test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 values: []),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "pickerText",
                                                                 title: "text test_title",
                                                                 subtitle: "test_subtitle",
                                                                 placeholder: "test_placeholder",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "value", localizationKey: "value_key")])])
    }
}
