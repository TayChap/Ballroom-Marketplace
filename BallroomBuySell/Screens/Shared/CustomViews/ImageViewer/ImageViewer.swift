//
//  ImageViewer.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-08-06.
//

import UIKit

class ImageViewer: UIPageViewController, UIPageViewControllerDataSource {
    private var images = [UIImage]()
    private var currentIndex = 1
    
    static func createViewController(_ images: [UIImage], at index: Int) -> UIViewController {
        let vc = UIViewController.getVC(from: .imageViewer, of: self)
        vc.images = images
        vc.currentIndex = index
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.Color.cardBackground.value
        dataSource = self
        setViewControllers([viewImageVC(currentIndex)],
                           direction: .forward,
                           animated: false)
    }
    
    // MARK: - UIPageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard currentIndex > 0 else {
            return nil
        }
        
        return viewImageVC(currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard currentIndex < images.count else {
            return nil
        }
        
        return viewImageVC(currentIndex + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        images.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
    
    // MARK: - Private Helpers
    private func viewImageVC(_ index: Int) -> UIViewController {
        currentIndex = index
        return ImageVC.createViewController(images[index])
    }
}
