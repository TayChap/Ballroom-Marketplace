//
//  SaleItemTemplate.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-07.
//

struct SaleItemTemplate: Codable {
    var name: String
    //var previewCellStructure: [SaleItemPreviewCellStructure]
    var cellStructure: [SaleItemCellStructure] // screenStructure
}
