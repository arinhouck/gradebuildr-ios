//
//  CourseDetailController.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/21/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit

class CourseDetailController: UIViewController {
    
    var course: Course?
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixItView = UIView()
        fixItView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20);
        fixItView.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        view.addSubview( fixItView )
        
        navigationBar.topItem?.title = course!.getName()
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
