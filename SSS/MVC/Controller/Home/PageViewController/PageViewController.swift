//
//  PageController.swift
//  SSS
//
//  Created by Sierra 4 on 15/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let titles:[String] = ["COMPLAINT", "HOME", "RECORDING"]
    var pageIndex:Int = 0
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("ComplaintListViewController"),
                self.newViewController("HomeViewController"),
                self.newViewController("RecordingsViewController")]
    }()
    
    private func newViewController(_ name: String) -> UIViewController {
        return (storyboard?.instantiateViewController(withIdentifier: name))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navBarTitle()
    }
    
    func navBarTitle() {
        print(titles[pageIndex])
        navigationItem.title = titles[pageIndex]
    }
    
    @IBAction func profile(_ sender: Any) {
        print("Profile")
    }
    
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return orderedViewControllers.count
//    }
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllers?.first,
//            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
//                return 0
//        }
//        return firstViewControllerIndex
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if (!completed) {
//            return
//        }
//        
//        if let firstViewController = viewControllers?.first,
//            let arrayIndex = orderedViewControllers.index(of: firstViewController) {
//            pageIndex = arrayIndex
//            self.navBarTitle()
//        }
//    }
    
}














