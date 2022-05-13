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
    
    private var thread: MessageThread
    private let user: User
    private let templates: [SaleItemTemplate]
    
    // MARK: - Lifecycle Methods
    init(owner: ViewControllerProtocol, thread: MessageThread, user: User, templates: [SaleItemTemplate]) {
        delegate = owner
        self.thread = thread
        self.user = user
        self.templates = templates
        
        self.thread.userIds.insert(user.id)
    }
    
    // MARK: - IBActions
    func backButtonClicked() {
        delegate?.dismiss()
    }
    
    func reportButtonClicked() {
        Report.submitReport(for: thread,
                            with: LocalizedString.string("flag.reason"),
                            delegate: delegate,
                            reportingUser: user) {
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
        } onFail: {
            self.delegate?.showNetworkError()
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
        DatabaseManager.sharedInstance.putDocument(in: .threads,
                                                   for: thread) {
            // no action on completion
        } onFail: {
            delegate?.showNetworkError()
        }
    }
    
    // MARK: - Public Helpers
    func setTitle(_ completion: @escaping (String) -> Void) {
        DatabaseManager.sharedInstance.getDocument(in: .users,
                                                   of: User.self,
                                                   with: thread.userId) { user in
            completion(user.displayName)
        } onFail: {
            // no action required
        }
    }
}
