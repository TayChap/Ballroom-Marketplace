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

class MessageThreadVC: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    // MARK: - Lifecycle Methods
    static func createViewController(/*_ thread: MessageThread*/) -> UIViewController {
        let vc = UIViewController.getVC(from: .main, of: self)
        //vc.vm = MessageThreadVM()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
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
