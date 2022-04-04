//
//  TextViewTableCell.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-03-26.
//

import UIKit

protocol TextViewCellDelegate {
    func textDidBeginEditing(_ cell: TextViewTableCell)
    func updateTextViewDetail(_ newText: String, for cell: TextViewTableCell)
}

class TextViewTableCell: UITableViewCell, UITextViewDelegate, TableCellProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: TextViewCellDelegate?
    
    private let maxTextViewHeight: CGFloat = 100
    private var textViewIsOversized = false {
        didSet {
            guard oldValue != textViewIsOversized else {
                return
            }
            
            textView.isScrollEnabled = textViewIsOversized
            textView.setNeedsUpdateConstraints()
        }
    }
    
    static func registerCell(for tableView: UITableView) {
        let identifier = String(describing: TextViewTableCell.self)
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(for tableView: UITableView) -> TextViewTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextViewTableCell.self)) as? TextViewTableCell else {
            assertionFailure("Can't Find Cell")
            return nil
        }
        
        return cell
    }
    
    func configureCell(with dm: TextViewCellDM) {
        clearContent()
        
        titleLabel.text = dm.title
        textView.text = dm.detail
        textView.isEditable = dm.isEnabled
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = Theme.Color.primaryText.value.cgColor
        textView.delegate = self
    }
    
    func clearContent() {
        titleLabel.text = ""
        textView.text = ""
    }
    
    // MARK: - TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        guard let newText = textView.text else {
            return
        }
        
        delegate?.updateTextViewDetail(newText, for: self)
        textViewIsOversized = textView.contentSize.height > maxTextViewHeight
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textDidBeginEditing(self)
        textView.layer.borderColor = Theme.Color.interactivity.value.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = Theme.Color.primaryText.value.cgColor
    }
}
