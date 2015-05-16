//
//  MyNavigationViewController.swift
//  Tiny3DViewer
//
//  Created by yoshimura on 2015/03/17.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation
import UIKit

class MyNavigationViewController:UINavigationController {
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        
//        println(toViewController)
//        
//        return super.segueForUnwindingToViewController(toViewController,fromViewController:fromViewController,identifier:identifier)
//    }
//    
//    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
//        return true
//    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
}
