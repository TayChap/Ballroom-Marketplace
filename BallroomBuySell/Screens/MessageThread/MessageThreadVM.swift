//
//  MessageThreadVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class MessageThreadVM { // TODO! deal with sim access issue and change to struct
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
        
        self.thread.userIds.insert(user.id)
    }
    
    // MARK: - IBActions
    func infoButtonClicked() {
        DatabaseManager.sharedInstance.getSaleItems(where: ("id", thread.saleItemId)) { saleItems in
            guard var saleItem = saleItems.first else {
                return
            }
            
            Image.downloadImages(saleItem.images.map({ $0.url })) { images in
                if !self.templates.isEmpty {
                    saleItem.images = images
                    self.delegate?.pushViewController(SaleItemViewVC.createViewController(templates: self.templates,
                                                                                          saleItem: saleItem,
                                                                                          hideContactSeller: true))
                }
            }
        }
    }
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        Sender(senderId: user.id, displayName: user.displayName, imageURL: user.photoURL)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        thread.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        thread.messages[indexPath.section]
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let imageURL = (message.sender as? Sender)?.imageURL else {
            return
        }
        
        ImageManager.sharedInstance.downloadImage(at: imageURL) { data in
            avatarView.image = UIImage(data: data)
        }
    }
    
    func inputBar(didPressSendButtonWith text: String, _ completion: () -> Void) {
        let message = Message(content: text,
                              senderId: user.id,
                              sentDate: Date(),
                              imageURL: user.photoURL,
                              displayName: user.displayName)
        
        thread.messages.append(message)
        completion()
        DatabaseManager.sharedInstance.createDocument(.threads, thread, thread.id)
    }
}
