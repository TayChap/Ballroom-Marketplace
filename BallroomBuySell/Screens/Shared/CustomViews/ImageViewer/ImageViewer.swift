//
//  ImageViewer.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-08-06.
//

import UIKit

class ImageViewer: UIPageViewController, UIPageViewControllerDataSource {
    private var currentIndex = 1
    private var images = [UIImage]()
    
    static func createViewController(_ images: [UIImage]) -> UIViewController {
        let vc = UIViewController.getVC(from: .imageViewer, of: self)
        vc.images = images
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setViewControllers([viewImageVC(currentIndex)],
                           direction: .forward,
                           animated: false)
    }
    
    // MARK: - UIPageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentIndex -= 1
        return viewImageVC(currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentIndex += 1
        return viewImageVC(currentIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        images.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
    
    // MARK: - Private Helpers
    private func viewImageVC(_ index: Int) -> UIViewController {
        ImageVC.createViewController(images[index])
    }
}
