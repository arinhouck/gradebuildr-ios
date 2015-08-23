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
                var alertView = UIAlertView();
                alertView.addButtonWithTitle("Ok")
                alertView.title = "Login"
                alertView.message = "\(response)"
                alertView.show()
        }
    }
    
    
}