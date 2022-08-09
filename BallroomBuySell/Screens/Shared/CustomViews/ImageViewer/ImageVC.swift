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
    
    // MARK: - Life Cycle
    static func createViewController(_ image: UIImage) -> UIViewController {
        let vc = UIViewController.getVC(from: .imageViewer, of: self)
        vc.image = image
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
