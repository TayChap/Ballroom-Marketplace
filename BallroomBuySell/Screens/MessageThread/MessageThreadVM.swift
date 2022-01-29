//
//  MessageThreadVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import UIKit

struct MessageThreadVM {
    private weak var delegate: ViewControllerProtocol?
    private var thread: MessageThread
    private var templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ thread: MessageThread, _ templates: [SaleItemTemplate]) {
        delegate = owner
        self.thread = thread
        self.templates = templates
    }
    
    // MARK: - IBActions
    func infoButtonClicked() {
        //ViewItemVC.createViewController(templates, )
    }
}
