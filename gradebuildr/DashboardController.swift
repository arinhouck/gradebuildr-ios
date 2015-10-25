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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        do {
            try keychain.remove("user-token")
        } catch let error {
            print("error: \(error)")
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("userLoggedIn")
        
        self.performSegueWithIdentifier("root", sender: nil)
    }
        
}