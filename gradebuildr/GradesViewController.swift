//
//  GradesViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 10/30/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class GradesViewController: UIViewController {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = API_URL
        static var token: String?
        
        case CreateGrade([String: AnyObject])
        case ReadGrade([String: AnyObject])
        case UpdateGrade(String, [String: AnyObject])
        case DestroyGrade(String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateGrade:
                return .POST
            case .ReadGrade:
                return .GET
            case .UpdateGrade:
                return .PUT
            case .DestroyGrade:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateGrade:
                return "/grades"
            case .ReadGrade:
                return "/grades"
            case .UpdateGrade(let id, _):
                return "/grades/\(id)"
            case .DestroyGrade(let id):
                return "/grades/\(id)"
            }
        }
        
        // MARK: URLRequestConvertible
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = Router.token {
                mutableURLRequest.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .CreateGrade(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadGrade(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateGrade(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    let keychain = Keychain(service: "com.gradebuildr.user-token")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Router.token = keychain["user-token"]
        let request = Alamofire.request(Router.ReadGrade(["user_id": 4]))
            .responseString(completionHandler: { response in
                print(response.request)
                print(response.response)
                print(response.result.value)
                let jsonResponse = response.result.value
                if let dataFromString = jsonResponse!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    for (_, grades):(String, JSON) in json {
                        for grade:(String, JSON) in grades {
                            for (key, value) in grade.1 {
                                print(key, value)
                            }
                        }
                    }
                }
            })
        print("----")
        
        debugPrint(request)
        
//        let token = keychain["user-token"]
//        
//        let headers = [
//            "Authorization": "Token token=\"\(token)\"",
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
//        
//        Alamofire.request(
//            .GET,
//            API_URL + "grades/651",
//            parameters: nil,
//            headers: headers,
//            encoding: .JSON
//            ).responseString { response in
//                print(response.request)
//                print(response.response)
//                print(response.result.value)
//                
//        }

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
