//
//  ImageViewer.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-14.
//

import UIKit

class ImageViewer: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var image: UIImage!
    
    // MARK: - Life Cycle
    static func createViewController(_ image: UIImage) -> UIViewController {
        let vc = ImageViewer(nibName: String(describing: ImageViewer.self), bundle: nil)
        vc.image = image
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func closeButtonClicked() {
        dismiss(animated: true)
    }
}
