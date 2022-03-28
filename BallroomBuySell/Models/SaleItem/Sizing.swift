//
//  Sizing.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-27.
//

enum Sizing: String, Codable {
    case standard, dress, shirt, pant, skirt, tails, mensFlatShoes, womensFlatShoes, mensHeelShoes, womansHeelShoes
    
    var measurementCells: [SaleItemCellStructure] {
        switch self {
        case .standard:
            return [standardSizeCell]
        case .tails:
            return []
        case .dress:
            return [standardSizeOptionCell, standardSizeCell] +
                    [chest, waist, hips, inseam, sleeveLength, sleeveWidth]
        case .shirt:
            return [standardSizeOptionCell, standardSizeCell] +
            [chest, sleeveLength, sleeveWidth]
        case .pant, .skirt:
            return [standardSizeOptionCell, standardSizeCell] +
            [waist, inseam]
        case .mensFlatShoes, .womensFlatShoes:
            return [shoeSize]
        case .mensHeelShoes, .womansHeelShoes:
            return [shoeSize, heelHeight]
        }
    }
    
    // MARK: - Private Helpers
    private var standardSizeOptionCell: SaleItemCellStructure {
        SaleItemCellStructure(type: .toggle,
                              inputType: .standard,
                              serverKey: "",
                              title: "use std sizes?",
                              subtitle: "",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: false)
    }
    
    private var standardSizeCell: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .standardSize,
                              serverKey: "standardSize",
                              title: "standardSize",
                              subtitle: "",
                              placeholder: "",
                              required: true,
                              filterEnabled: true,
                              values: [PickerValue(serverKey: "", localizationKey: ""),
                                       PickerValue(serverKey: "XXS", localizationKey: "xxs_key"),
                                       PickerValue(serverKey: "XS", localizationKey: "xs_key"),
                                       PickerValue(serverKey: "S", localizationKey: "s_key"),
                                       PickerValue(serverKey: "M", localizationKey: "m_key"),
                                       PickerValue(serverKey: "L", localizationKey: "l_key"),
                                       PickerValue(serverKey: "XL", localizationKey: "xl_key"),
                                       PickerValue(serverKey: "XXL", localizationKey: "xxl_key")])
    }
    
    private var chest: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "bust",
                              title: "text bust",
                              subtitle: "bust description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var waist: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "waist",
                              title: "text waist",
                              subtitle: "test_subtitle waist description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var hips: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "hips",
                              title: "text hips",
                              subtitle: "test_subtitle hips description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var inseam: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "inseam",
                              title: "text inseam",
                              subtitle: "test_subtitle inseam description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var sleeveLength: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "sleeveLength",
                              title: "text arm_length",
                              subtitle: "test_subtitle arm description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var sleeveWidth: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "sleeveWidth",
                              title: "text arm_length",
                              subtitle: "test_subtitle arm description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var shoeSize: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                               inputType: .measurement,
                               serverKey: "mensShoesSize",
                               title: "shoe size (US SIZING INDICATOR)",
                               subtitle: "test_subtitle arm description",
                               placeholder: "test_placeholder",
                               required: false,
                               filterEnabled: true,
                               min: 4.0,
                               max: 16.0,
                               increment: 0.5)
    }
    
    private var heelHeight: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "heelHeight",
                              title: "text arm_length",
                              subtitle: "test_subtitle arm description",
                              placeholder: "test_placeholder",
                              required: false,
                              filterEnabled: true,
                              min: 0.0,
                              max: 5.0,
                              increment: 0.5)
    }
}
