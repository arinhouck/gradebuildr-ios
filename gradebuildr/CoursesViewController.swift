//
//  CoursesViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 10/30/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.topItem?.title = "Courses"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
