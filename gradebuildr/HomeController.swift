//
//  HomeController.swift
//  gradebuildr
//
//  Created by Arin Houck on 8/24/15.
//  Copyright (c) 2015 Gradebuildr. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("userLoggedIn") != nil {
            if let dashboard = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as? TabBarController {
                self.navigationController?.pushViewController(dashboard, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}