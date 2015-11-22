//
//  DashboardController.swift
//  gradebuildr
//
//  Created by Arin Houck on 8/24/15.
//  Copyright (c) 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class DashboardController: UIViewController {
    
    var user: User?
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var courseCountLabel: UILabel!
    @IBOutlet weak var gradeCountLabel: UILabel!
    @IBOutlet weak var semesterGpaLabel: UILabel!
    @IBOutlet weak var cumulativeGpaLabel: UILabel!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
    }
    
    override func viewDidAppear(animated: Bool) {
        User.Router.token = keychain["user-token"]
        
        _ = Alamofire.request(User.Router.ReadUser(["id": keychain["user-id"]!]))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json: JSON = JSON(value)
                        let u: JSON = json["user"]
                        self.user = User(user: u)
                    }
                    
                    self.loadUser()
                case .Failure(let error):
                    print(error)
                }
            })
    }
    
    private func loadUser() {
        dispatch_async(dispatch_get_main_queue(), {
            self.courseCountLabel.text = "\(self.user!.getCourseCount())"
            self.gradeCountLabel.text = "\(self.user!.getGradeCount())"
            self.semesterGpaLabel.text = "\(self.user!.getSemesterGpa())"
            self.cumulativeGpaLabel.text = "\(self.user!.getCumulativeGpa())"
            return
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
}