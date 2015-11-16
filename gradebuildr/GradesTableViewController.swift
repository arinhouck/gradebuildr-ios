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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.refreshControl = UIRefreshControl()
        
        // set up the refresh control
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        gradesTableView.addSubview(refreshControl!)
        
        self.loadGrades()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender:AnyObject) {
        grades.rows.removeAll()
        self.loadGrades()
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
        let ratio = " \(grades.rows[indexPath.row].getScore()) \\ \(grades.rows[indexPath.row].getScoreTotal())"
        cell.detailTextLabel?.text = ratio
        
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
    
    private func loadGrades() {
        Grades.Router.token = keychain["user-token"]
        
        _ = Alamofire.request(Grades.Router.ReadGrade(["user_id": keychain["user-id"]!]))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json: JSON = JSON(value)
                        for grade in json["grades"].arrayValue {
                            self.grades.rows.append(Grade(grade: grade))
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
            self.gradesTableView.reloadData()
            return
        })
    }

}
