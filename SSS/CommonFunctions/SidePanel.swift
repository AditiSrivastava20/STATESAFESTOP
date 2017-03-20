//
//  SidePanel.swift
//  SSS
//
//  Created by Sierra 4 on 20/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import Foundation
import UIKit

enum Direction{
    
    case left
    case right
    
    var direction : CGFloat {
        
        switch self {
        case .left:
            return  -UIScreen.main.bounds.size.width
        case .right:
            return UIScreen.main.bounds.size.width
        }
    }
    var backdirection : CGFloat {
        
        switch self {
        case .left:
            return -UIScreen.main.bounds.size.width
        case .right:
            return UIScreen.main.bounds.size.width
        }
    }
}


class SidePanel {
    
    static let shared = SidePanel()
    
    func ShowPanel(obj: UIViewController , opr : Direction, identifier: String, completionHandler: @escaping () -> ())
    {
        let OptionViewController : UIViewController = obj.storyboard!.instantiateViewController(withIdentifier: identifier)
        obj.view.addSubview(OptionViewController.view)
        obj.addChildViewController(OptionViewController)
        OptionViewController.view.layoutIfNeeded()
        OptionViewController.view.frame = CGRect(x: opr.direction , y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            OptionViewController.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:{ completed in
            if completed {
                completionHandler()
            }
        })
    }
    
}


class Back
{
    class func backPanel(obj: UIViewController,opr: Direction)
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            obj.view.frame = CGRect(x: opr.backdirection, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            obj.view.layoutIfNeeded()
            obj.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            obj.view.removeFromSuperview()
            obj.removeFromParentViewController()
        })
    }
}

