//
//  MessageThreadVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit

class MessageThreadVM { // TODO! change back to struct ?
    private weak var delegate: ViewControllerProtocol?
    private var thread: MessageThread
    private let user: User
    private let templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(_ owner: ViewControllerProtocol, _ thread: MessageThread, _ user: User, _ templates: [SaleItemTemplate]) {
        delegate = owner
        self.thread = thread
        self.user = user
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
                              senderId: user.id,
                              displayName: user.displayName)
        
        thread.messages.append(message)
        completion()
        DatabaseManager.sharedInstance.createDocument(.threads, thread, thread.id)
    }
}
