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
                getShoesTemplate()
            ]
            
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
                                                                 filterEnabled: false),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "armLength",
                                                                 title: "text arm_length",
                                                                 subtitle: "test_subtitle arm description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5)])
    }
    
    private static func getStandardDressTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "standardDress",
                         name: "standardDress",
                         imageURL: "\(imageURLPrefix)standardDress",
                         screenStructure: [SaleItemCellStructure(type: .toggle,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "remove", // TODO!
                                                                 title: "use std sizes?",
                                                                 subtitle: "",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: false),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "standardSize",
                                                                 title: "standardSize",
                                                                 subtitle: "",
                                                                 placeholder: "",
                                                                 required: true,
                                                                 filterEnabled: true,
                                                                 sizing: .standard,
                                                                 values: [PickerValue(serverKey: "", localizationKey: ""),
                                                                          PickerValue(serverKey: "XXS", localizationKey: "xxs_key"),
                                                                          PickerValue(serverKey: "XS", localizationKey: "xs_key"),
                                                                          PickerValue(serverKey: "S", localizationKey: "s_key"),
                                                                          PickerValue(serverKey: "M", localizationKey: "m_key"),
                                                                          PickerValue(serverKey: "L", localizationKey: "l_key"),
                                                                          PickerValue(serverKey: "XL", localizationKey: "xl_key"),
                                                                          PickerValue(serverKey: "XXL", localizationKey: "xxl_key")]),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "bust",
                                                                 title: "text bust",
                                                                 subtitle: "bust description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 sizing: .measurements,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "waist",
                                                                 title: "text waist",
                                                                 subtitle: "test_subtitle waist description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 sizing: .measurements,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "hips",
                                                                 title: "text hips",
                                                                 subtitle: "test_subtitle hips description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 sizing: .measurements,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "inseam",
                                                                 title: "text inseam",
                                                                 subtitle: "test_subtitle inseam description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 sizing: .measurements,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5),
                                           SaleItemCellStructure(type: .picker,
                                                                 inputType: InputType.standard,
                                                                 serverKey: "armLength",
                                                                 title: "text arm_length",
                                                                 subtitle: "test_subtitle arm description",
                                                                 placeholder: "test_placeholder",
                                                                 required: false,
                                                                 filterEnabled: true,
                                                                 sizing: .measurements,
                                                                 min: 0.5,
                                                                 max: 10.0,
                                                                 increment: 0.5)])
    }
    
    private static func getShoesTemplate() -> SaleItemTemplate {
        SaleItemTemplate(id: "shoes",
                         name: "shoes_key",
                         imageURL: "\(imageURLPrefix)shoes",
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
                                                                 filterEnabled: true),
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
