//
//  ImageVC.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

class ImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage!
    private(set) var index: Int?
    
    // MARK: - Life Cycle
    static func createViewController(_ image: UIImage, at index: Int? = nil) -> UIViewController {
        let vc = UIViewController.getVC(from: .imageViewer, of: self)
        vc.image = image
        vc.index = index
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
