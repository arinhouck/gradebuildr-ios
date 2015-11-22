//
//  TabBarController.swift
//  gradebuildr
//
//  Created by Arin Houck on 10/24/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        
        self.view.addSubview(view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
