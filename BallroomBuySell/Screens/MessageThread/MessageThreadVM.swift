//
//  MessageThreadVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit

class MessageThreadVM {
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
        //ViewItemVC.createViewController(templates, saleItem)
    }
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        Sender(senderId: "123", displayName: "123") // TODO! evaluate multiple appearances
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        thread.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        thread.messages[indexPath.section]
    }
    
    func inputBar(didPressSendButtonWith text: String, _ completion: () -> Void) {
        let message = Message(content: text,
                              messageId: UUID().uuidString,
                              sentDate: Date(),
                              senderId: "",
                              displayName: "")
        
        // save(message) TODO! save to server {
            thread.messages.append(message)
            completion()
        //}
    }
}
