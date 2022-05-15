//
//  MessageThreadVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class MessageThreadVC: MessagesViewController, ViewControllerProtocol, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var reportButton: UIBarButtonItem!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    private var vm: MessageThreadVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ thread: MessageThread,
                                     currentUser: User,
                                     otherUser: User,
                                     templates: [SaleItemTemplate],
                                     hideItemInfo: Bool = false) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        
        if hideItemInfo { // navigation is from item info page already
            vc.navigationItem.rightBarButtonItem = nil
        }
        
        vc.vm = MessageThreadVM(owner: vc,
                                thread: thread,
                                currentUser: currentUser,
                                otherUser: otherUser,
                                templates: templates)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vm.title
        
        // message collection view settings
        messageInputBar.delegate = self
        messagesCollectionView.backgroundColor = Theme.Color.background.value
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - IBActions
    @IBAction func backButtonClicked() {
        vm.backButtonClicked()
    }
    
    @IBAction func reportButtonClicked() {
        vm.reportButtonClicked()
    }
    
    @IBAction func infoButtonClicked() {
        vm.infoButtonClicked()
    }
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        vm.currentSender()
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        vm.numberOfSections(in: messagesCollectionView)
    }
    
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        vm.messageForItem(at: indexPath, in: messagesCollectionView)
    }
    
    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        vm.configureAvatarView(avatarView, for: message, at: indexPath, in: messagesCollectionView)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView,
                  didPressSendButtonWith text: String) {
        vm.inputBar(didPressSendButtonWith: text) {
            inputBar.inputTextView.text = ""
            reload()
        }
    }
    
    // MARK: - ViewControllerProtocol
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func reload() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
}
