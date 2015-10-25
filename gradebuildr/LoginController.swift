//
//  LoginController.swift
//  gradebuildr
//
//  Created by Arin Houck on 8/23/15.
//  Copyright (c) 2015 Gradebuildr. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

let API_URL = "https://www.gradebuildr.com/"

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var swipeView: UIView!
    
    let swipeRec = UISwipeGestureRecognizer()
    
    var keyboardMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        swipeRec.addTarget(self, action: "swipedView")
        swipeView.addGestureRecognizer(swipeRec)
        swipeView.userInteractionEnabled = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func swipedView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardMoved {
            self.view.frame.origin.y -= 150
            keyboardMoved = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += 150
        keyboardMoved = false
    }
    
    @IBAction func login(sender : UIButton){
        
        if (email.text!.isEmpty || password.text!.isEmpty) { // Validation for email and password
            self.alert("Login", message: "Please enter an email and password.", buttonText: "Okay")
            return
        }
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(
            .POST,
            API_URL + "users/sign_in",
            parameters: ["user":
                ["email": email.text!, "password": password.text!]
            ],
            headers: headers,
            encoding: .JSON
            ).responseString { response in
                print(response.request)
                print(response.response)
                print(response.result.value)
                
                if (response.response?.statusCode == 201) {
                    // Sucessful request
                    self.alert("Login", message: "\(response)", buttonText: "Okay")
                    self.storeKeychain(response.result.value!)
                    self.updateUserLoggedInFlag()
                    self.performSegueWithIdentifier("dashboard", sender: nil)
                } else {
                    // Unauthorized Request
                    self.alert("Login", message: "Invalid email or password.", buttonText: "Okay")
                }
                
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    private func storeKeychain(jsonResponse: String) {
        let keychain = Keychain(service: "com.gradebuildr.user-token")
        
        if let dataFromString = jsonResponse.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            keychain[string: "user-token"] = json["token"].string
        }
    }
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    private func alert(title: String, message: String, buttonText: String) {
        var alertView = UIAlertView();
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle(buttonText)
        alertView.show()
    }
    
    
}