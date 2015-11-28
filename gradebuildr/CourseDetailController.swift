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
    var weights: Weights = Weights()
    
    @IBOutlet weak var containerView: UIView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    @IBOutlet weak var currentLetterGradeLabel: UILabel!
    @IBOutlet weak var creditHoursLabel: UILabel!
    @IBOutlet weak var gradingScaleLabel: UILabel!
    
    @IBOutlet weak var currentGradeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixItView = UIView()
        fixItView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20);
        fixItView.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        view.addSubview( fixItView )
        
        
        self.title = course?.getName()
        self.currentLetterGradeLabel.text = course?.getLetterGrade()
        self.currentGradeLabel.text = "\(course!.getCurrentGrade()) %"
        self.creditHoursLabel.text = "\(course!.getCreditHours())"
        self.gradingScaleLabel.text = course?.getGradingScale()
        // Do any additional setup after loading the view.
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "chart" {
            let destination: PieChartViewController =  segue.destinationViewController as! PieChartViewController
            destination.course = course
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
