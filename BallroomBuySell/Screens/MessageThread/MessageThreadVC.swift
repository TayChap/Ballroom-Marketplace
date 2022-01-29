//
//  MessageThreadVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-28.
//

import MessageKit

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}

// Some global variables for the sake of the example. Using globals is not recommended!
let sender = Sender(senderId: "any_unique_id", displayName: "Steven")
let messages: [MessageType] = []

class MessageThreadVC: MessagesViewController, ViewControllerProtocol, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
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
        Sender(senderId: "any_unique_id", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
}
