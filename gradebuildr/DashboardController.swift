//
//  DashboardController.swift
//  gradebuildr
//
//  Created by Arin Houck on 8/24/15.
//  Copyright (c) 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess

class DashboardController: UIViewController {
    
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    @IBOutlet var mainView: UIView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
}