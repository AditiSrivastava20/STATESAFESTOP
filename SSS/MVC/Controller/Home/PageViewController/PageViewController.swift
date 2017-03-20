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
    let btn1 = MaterialButton.shared.btn()
    
    let orderedViewControllers:[UIViewController] = [StoryboardScene.Main.instantiateComplaintListViewController(),
                StoryboardScene.Main.instantiateHomeViewController(),
                StoryboardScene.Main.instantiateRecordingsViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarButtons()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        navBarTitle()
    }
    
    func navBarTitle() {
        print(titles[pageIndex])
        navigationItem.title = titles[pageIndex]
    }
    
    func navbarButtons() {
        self.btn1.setImage(Image(asset: .icProfile), for: .normal)
        self.btn1.addTarget(self, action: #selector(profilePanel), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = MaterialButton.shared.btn()
        btn2.setImage(Image(asset: .icNotification), for: .normal)
        btn2.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
    }
    
    func profilePanel() {
        self.btn1.isEnabled = false
        SidePanel.shared.ShowPanel(obj: self,opr: .left,identifier: "ProfilePanel"){_ in
            self.btn1.isEnabled = true
        }
    }
    
    func notificationAction() {
        performSegue(withIdentifier: "notification", sender: nil)
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            return
        }
        
        if let firstViewController = viewControllers?.first,
            let arrayIndex = orderedViewControllers.index(of: firstViewController) {
            pageIndex = arrayIndex
            self.navBarTitle()
        }
    }
    
}














