//
//  Sizing.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-27.
//

enum Sizing: String, Codable { // TODO! enum naming
    enum StandardSize: String, Codable {
        case xxs, xs, s, m, l, xl, xxl
    }
    
    case standard, dress, shirt, pant, skirt, tails, mensShoes, womansShoes
    
    var measurementCells: [SaleItemCellStructure] {
        switch self {
        case .standard:
            return [standardSizeCell]
        case .tails:
            return [chest, waist, hips, sleeveLength, sleeveWidth, inseam, napeToWaist, waistToHip, neckCircumference]
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
                              required: false,
                              filterEnabled: true,
                              values: [PickerValue(serverKey: "", localizationKey: ""),
                                       PickerValue(serverKey: StandardSize.xxs.rawValue, localizationKey: "sale.item.sizing.xxs"),
                                       PickerValue(serverKey: StandardSize.xs.rawValue, localizationKey: "sale.item.sizing.xs"),
                                       PickerValue(serverKey: StandardSize.s.rawValue, localizationKey: "sale.item.sizing.s"),
                                       PickerValue(serverKey: StandardSize.m.rawValue, localizationKey: "sale.item.sizing.m"),
                                       PickerValue(serverKey: StandardSize.l.rawValue, localizationKey: "sale.item.sizing.l"),
                                       PickerValue(serverKey: StandardSize.xl.rawValue, localizationKey: "sale.item.sizing.xl"),
                                       PickerValue(serverKey: StandardSize.xxl.rawValue, localizationKey: "sale.item.sizing.xxl")])
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
                              min: 15.0,
                              max: 70.0,
                              increment: 0.5,
                              measurements: [StandardSize.xxs: 31.0,
                                             StandardSize.xs: 33.0,
                                             StandardSize.s: 35.0,
                                             StandardSize.m: 37.0,
                                             StandardSize.l: 40.0,
                                             StandardSize.xl: 44.0,
                                             StandardSize.xxl: 48.0])
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
                              min: 15.0,
                              max: 60.0,
                              increment: 0.5,
                              measurements: [StandardSize.xxs: 22.5,
                                             StandardSize.xs: 24.5,
                                             StandardSize.s: 26.5,
                                             StandardSize.m: 28.5,
                                             StandardSize.l: 32.0,
                                             StandardSize.xl: 38.0,
                                             StandardSize.xxl: 42.5])
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
                              min: 15.0,
                              max: 60.0,
                              increment: 0.5,
                              measurements: [StandardSize.xxs: 33.5,
                                             StandardSize.xs: 35.5,
                                             StandardSize.s: 37.5,
                                             StandardSize.m: 39.5,
                                             StandardSize.l: 42.5,
                                             StandardSize.xl: 48.0,
                                             StandardSize.xxl: 52.0])
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
                              min: 10.0,
                              max: 40.0,
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
                              min: 10.0,
                              max: 40.0,
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
                              max: 15.0,
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
                              max: 25.0,
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
    
    // MARK: - Tailsuit Specific
    private var napeToWaist: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "napeToWaist",
                              titleKey: "sale.item.sizing.nape.to.waist",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: true,
                              min: 5.0,
                              max: 60.0, // TODO! proper max
                              increment: 0.5)
    }
    
    private var waistToHip: SaleItemCellStructure {
        SaleItemCellStructure(type: .picker,
                              inputType: .measurement,
                              serverKey: "waistToHip",
                              titleKey: "sale.item.sizing.waist.to.hip",
                              subtitleKey: "",
                              placeholderKey: "",
                              required: false,
                              filterEnabled: true,
                              min: 0.5,
                              max: 30.0, // TODO! proper max
                              increment: 0.5)
    }
}
