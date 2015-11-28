//
//  EditProfileViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 10/30/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class EditProfileViewController: UIViewController {
    
    var user: User?
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var gradePointsTextField: UITextField!
    @IBOutlet weak var gradeUnitsTextField: UITextField!
    
    @IBOutlet weak var semesterPickerView: UIPickerView!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fixItView = UIView()
        fixItView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20);
        fixItView.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.40, alpha:1.0)
        view.addSubview( fixItView )
        
        
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
            self.firstNameTextField.becomeFirstResponder()
            self.firstNameTextField.text = self.user?.getFirstName()
            self.lastNameTextField.text = self.user?.getLastName()
            self.gradePointsTextField.text = "\(self.user!.getGradePoints())"
            self.gradeUnitsTextField.text = "\(self.user!.getGradeUnits())"
            
            self.emailTextField.text = self.user?.getEmail()
            return
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func save(sender: AnyObject) {
        
        User.Router.token = keychain["user-token"]
        
        let params = [
            User.UserFields.FirstName.rawValue: firstNameTextField.text!,
            User.UserFields.LastName.rawValue: lastNameTextField.text!,
            User.UserFields.GradePoints.rawValue: gradePointsTextField.text!,
            User.UserFields.GradeUnits.rawValue: gradeUnitsTextField.text!,
            User.UserFields.Email.rawValue: emailTextField.text!
        ]
        
        let update = [
            "id": keychain["user-id"]!,
            "user" : params
        ]
        
        _ = Alamofire.request(User.Router.UpdateUser(update))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    self.alert("User", message: "Sucessfully updated profile.", buttonText: "Okay")
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            })
        
    }
    
    private func alert(title: String, message: String, buttonText: String) {
        let alertView = UIAlertView();
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle(buttonText)
        alertView.show()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
