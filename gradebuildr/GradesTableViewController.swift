//
//  GradesTableViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/14/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class GradesTableViewController: UITableViewController {
    
    @IBOutlet weak var gradesTableView: UITableView!
    
    var grades: Grades = Grades()
    
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
    
    
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    private func loadGrades() {
        Router.token = keychain["user-token"]
        
        _ = Alamofire.request(Router.ReadGrade(["user_id": keychain["user-id"]!]))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json: JSON = JSON(value)
                        for grade in json["grades"].arrayValue {
                            let id = grade["id"].int!
                            let name = grade["name"].stringValue
                            let score = grade["score"].int!
                            let scoreTotal = grade["score_total"].int!
                            let percentage = grade["percentage"].doubleValue
                            let userId = grade["user_id"].int!
                            let courseId = grade["course_id"].int!
                            let weightId = grade["weight_id"].int!
                            let createdAt = grade["created_at"].stringValue
                            
                            self.grades.rows.append(Grade(id: id, name: name, score: score, scoreTotal: scoreTotal, percentage: percentage, userId: userId, courseId: courseId, weightId: weightId, createdAt: createdAt))
                            
                        }
                    }
                    
                    self.reloadTableView()
                case .Failure(let error):
                    print(error)
                }
            })

    }
    
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.gradesTableView.reloadData()
            return
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGrades()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return grades.rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gradeCell", forIndexPath: indexPath)

        cell.textLabel?.text = grades.rows[indexPath.row].getName();

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
