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

let API_URL = "http://localhost:3000/"

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender : UIButton){
        
        if (email.text.isEmpty || password.text.isEmpty) { // Validation for email and password
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
                ["email": email.text, "password": password.text]
            ],
            headers: headers,
            encoding: .JSON
            ).responseString {
                (request, response, string, error) in
                println(request)
                println(response)
                println(string)
                if (response?.statusCode == 201) {
                    // Sucessful request
                    self.alert("Login", message: "\(response)", buttonText: "Okay")
                } else {
                    // Unauthorized Request
                    self.alert("Login", message: "Invalid email or password.", buttonText: "Okay")
                }
                
        }
    }
    
    private func alert(title: String, message: String, buttonText: String) {
        var alertView = UIAlertView();
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle(buttonText)
        alertView.show()
    }
    
    
}