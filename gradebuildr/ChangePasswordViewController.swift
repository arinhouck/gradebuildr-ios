//
//  ChangePasswordViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/28/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class ChangePasswordViewController: UIViewController {
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        
        
        self.newPasswordTextField.becomeFirstResponder()
        
        
    }
    
    private func alert(title: String, message: String, buttonText: String) {
        let alertView = UIAlertView();
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle(buttonText)
        alertView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func save(sender: AnyObject) {
        
        User.Router.token = keychain["user-token"]
        
        let params = [
            "password": newPasswordTextField.text!,
            "password_confirmation": confirmPasswordTextField.text!,
        ]
        
        let update = [
            "id": keychain["user-id"]!,
            "user" : params
        ]
        
        _ = Alamofire.request(User.Router.UpdateUser(update))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                     self.alert("User", message: "Sucessfully updated password.", buttonText: "Okay")
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                case .Failure(let error):
                    print(error)
                }
            })
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
