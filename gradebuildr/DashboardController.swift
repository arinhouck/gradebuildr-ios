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
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        
        self.view.addSubview(view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func logout() {
        do {
            try keychain.remove("user-token")
        } catch let error {
            print("error: \(error)")
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("userLoggedIn")
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.logout()
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
        
}