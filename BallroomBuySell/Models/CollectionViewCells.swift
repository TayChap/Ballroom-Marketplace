//
//  CollectionViewCells.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-29.
//

enum CollectionViewCells {
    case saleItem, category
    
    var dimensions: (width: Int, height: Int) {
        switch self {
        case .saleItem: return (width: 180, height: 200)
        case .category: return (width: 190, height: 250)
        }
    }
}
