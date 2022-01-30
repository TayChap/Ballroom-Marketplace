//
//  MessageThreadVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import InputBarAccessoryView
import MessageKit

class MessageThreadVC: MessagesViewController, ViewControllerProtocol, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    @IBOutlet weak var infoButton: UIBarButtonItem!
    private var vm: MessageThreadVM!
    
    // MARK: - Lifecycle Methods
    static func createViewController(_ thread: MessageThread, _ templates: [SaleItemTemplate]) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        vc.vm = MessageThreadVM(vc, thread, templates)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    // MARK: - IBActions
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
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        vm.messageForItem(at: indexPath, in: messagesCollectionView)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
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
        dismiss(animated: true)
    }
    
    func reload() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        // messagesCollectionView.scrollToBottom(animated: true)
    }
}
