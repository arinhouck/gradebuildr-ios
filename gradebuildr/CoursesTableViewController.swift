//
//  CoursesTableViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/16/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
import Alamofire

class CoursesTableViewController: UITableViewController {
    
    @IBOutlet weak var coursesTableView: UITableView!
    
    var courses: Courses = Courses()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.refreshControl = UIRefreshControl()
        
        // set up the refresh control
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        coursesTableView.addSubview(refreshControl!)
        
        self.loadCourses()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender:AnyObject) {
        courses.rows.removeAll()
        self.loadCourses()
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
        return courses.rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = courses.rows[indexPath.row].getName();
        cell.detailTextLabel?.text = "\(courses.rows[indexPath.row].getCurrentGrade()) \(courses.rows[indexPath.row].getLetterGrade())"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        
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
    
    
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    private func loadCourses() {
        Courses.Router.token = keychain["user-token"]
        
        _ = Alamofire.request(Courses.Router.ReadCourse(["user_id": keychain["user-id"]!]))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json: JSON = JSON(value)
                        for course in json["courses"].arrayValue {
                            self.courses.rows.append(Course(course: course))
                        }
                    }
                    
                    if self.refreshControl!.refreshing
                    {
                        self.refreshControl?.endRefreshing()
                    }
                    
                    self.reloadTableView()
                case .Failure(let error):
                    print(error)
                }
            })
        
    }
    
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.coursesTableView.reloadData()
            return
        })
    }

}
