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
    
    static func registerCell(_ tableView: UITableView)
    static func createCell(_ tableView: UITableView) -> Cell
    func configureCell(_ dm: DataModal)
    func clearContent()
}

extension TableCellProtocol {
    static func registerCell(_ tableView: UITableView) {} // some cells are associated with table view using IB instead
}
