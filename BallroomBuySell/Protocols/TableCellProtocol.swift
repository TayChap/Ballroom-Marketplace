//
//  TableCellProtocol.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2021-12-29.
//

import UIKit

protocol TableCellProtocol: UITableViewCell {
    associatedtype DataModal
    associatedtype Cell
    
    static func registerCell(for tableView: UITableView)
    static func createCell(for tableView: UITableView) -> Cell
    func configureCell(with dm: DataModal)
    func clearContent()
}

extension TableCellProtocol {
    static func registerCell(for tableView: UITableView) {} // some cells are associated with table view using IB instead
}
