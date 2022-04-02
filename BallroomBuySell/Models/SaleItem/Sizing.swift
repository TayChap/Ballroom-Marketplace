//
//  Sizing.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-27.
//

enum Sizing: String, Codable {
    case standard, dress, shirt, pant, skirt, tails, mensShoes, womansShoes
    
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
            [chest, sleeveLength, sleeveWidth, neckCircumference]
        case .pant, .skirt:
            return [standardSizeOptionCell, standardSizeCell] +
            [waist, inseam]
        case .mensShoes, .womansShoes:
            return [shoeSize, heelHeight]
        }
    }
    
    // MARK: - Private Helpers
    private var standardSizeOptionCell: SaleItemCellStructure {
        SaleItemCellStructure(type: .toggle,
                              inputType: .standard,
                              serverKey: "",
                              titleKey: "sale.item.sizing.standard.size.option",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: true)
    }
    
    private var standardSizeCell: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .standardSize,
                              serverKey: "standardSize",
                              titleKey: "sale.item.sizing.standard.size",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: true,
                              filterEnabled: true,
                              values: [PickerValue(serverKey: "", localizationKey: ""),
                                       PickerValue(serverKey: "xxs", localizationKey: "sale.item.sizing.xxs"),
                                       PickerValue(serverKey: "xs", localizationKey: "sale.item.sizing.xs"),
                                       PickerValue(serverKey: "s", localizationKey: "sale.item.sizing.s"),
                                       PickerValue(serverKey: "m", localizationKey: "sale.item.sizing.m"),
                                       PickerValue(serverKey: "l", localizationKey: "sale.item.sizing.l"),
                                       PickerValue(serverKey: "xl", localizationKey: "sale.item.sizing.xl"),
                                       PickerValue(serverKey: "xxl", localizationKey: "sale.item.sizing.xxl")])
    }
    
    private var chest: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "bust",
                              titleKey: "sale.item.sizing.bust",
                              subtitleKey: "",
                              placeholderKey: "",
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
                              titleKey: "sale.item.sizing.waist",
                              subtitleKey: "",
                              placeholderKey: "",
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
                              titleKey: "sale.item.sizing.hips",
                              subtitleKey: "",
                              placeholderKey: "",
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
                              titleKey: "sale.item.sizing.inseam",
                              subtitleKey: "",
                              placeholderKey: "",
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
                              titleKey: "sale.item.sizing.sleeve.length",
                              subtitleKey: "",
                              placeholderKey: "",
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
                              titleKey: "sale.item.sizing.sleeve.width",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 10.0,
                              increment: 0.5)
    }
    
    private var neckCircumference: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "neckCircumference",
                              titleKey: "sale.item.sizing.neck.circumference",
                              subtitleKey: "",
                              placeholderKey: "",
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
                               titleKey: "sale.item.sizing.shoe",
                               subtitleKey: "",
                               placeholderKey: "",
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
                              titleKey: "sale.item.sizing.heel",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: true,
                              min: 0.0,
                              max: 5.0,
                              increment: 0.5)
    }
}
