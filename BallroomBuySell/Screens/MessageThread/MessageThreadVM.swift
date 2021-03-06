//
//  MessageThreadVM.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class MessageThreadVM {
    private weak var delegate: ViewControllerProtocol?
    
    private let templates: [SaleItemTemplate]
    private var thread: MessageThread
    private let currentUser: User
    private let otherUser: User
    
    // MARK: - Computed Properties
    var title: String {
        otherUser.displayName
    }
    
    // MARK: - Lifecycle Methods
    init(owner: ViewControllerProtocol,
         thread: MessageThread,
         currentUser: User,
         otherUser: User,
         templates: [SaleItemTemplate]) {
        delegate = owner
        self.thread = thread
        self.templates = templates
        self.currentUser = currentUser
        self.otherUser = otherUser
        
        for (index, message) in thread.messages.enumerated() {
            let user = currentUser.id == message.senderId ? currentUser : otherUser
            self.thread.messages[index].imageURL = user.photoURL
            self.thread.messages[index].displayName = user.displayName
        }
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        delegate?.dismiss()
    }
    
    func reportButtonClicked() {
        Report.submitReport(for: thread,
                            with: LocalizedString.string("flag.reason"),
                            delegate: delegate,
                            reportingUser: currentUser) {
            self.delegate?.showAlertWith(message: LocalizedString.string("generic.success"))
        } onFail: {
            self.delegate?.showNetworkError()
        }
    }
    
    func infoButtonClicked() {
        DatabaseManager.sharedInstance.getDocument(in: .items,
                                                   of: SaleItem.self,
                                                   with: thread.saleItemId) { saleItemFetched in
            var saleItem = saleItemFetched
            Image.downloadImages(saleItem.images.map({ $0.url })) { images in
                if !self.templates.isEmpty {
                    saleItem.images = images
                    self.delegate?.pushViewController(SaleItemVC.createViewController(mode: .view,
                                                                                      templates: self.templates,
                                                                                      saleItem: saleItem,
                                                                                      hideContactSeller: true))
                }
            }
        } onFail: { // fail EITHER due to network error or 404
            if !Reachability.isConnectedToNetwork {
                self.delegate?.showNetworkError()
                return
            }
            
            self.delegate?.showAlertWith(message: LocalizedString.string("alert.sale.item.removed"))
        }
    }
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        Sender(senderId: currentUser.id,
               displayName: currentUser.displayName,
               imageURL: currentUser.photoURL)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        thread.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        thread.messages[indexPath.section]
    }
    
    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        guard let imageURL = (message.sender as? Sender)?.imageURL else {
            return
        }
        
        ImageManager.sharedInstance.downloadImage(at: imageURL) { data in
            avatarView.image = UIImage(data: data)
        }
    }
    
    func inputBar(didPressSendButtonWith text: String, _ completion: () -> Void) {
        let message = Message(content: text,
                              senderId: currentUser.id,
                              sentDate: Date(),
                              imageURL: currentUser.photoURL,
                              displayName: currentUser.displayName)
        
        thread.messages.append(message)
        completion()
        DatabaseManager.sharedInstance.putDocument(in: .threads,
                                                   for: thread) {
            // no action on completion
        } onFail: {
            delegate?.showNetworkError()
        }
    }
}
