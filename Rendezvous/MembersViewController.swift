//
//  MembersViewController.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class MembersViewController: UITableViewController {
    //var members:[Member] = member_data
    var members:[Member] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        dataService.CURRENT_SELECTED_EVENT_GUESTS_REF.observeEventType(.Value, withBlock: { snapshot in
            
            self.members = []
            
            // Snapshot of user's events
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    let name = snap.value["Name"] as? String
                    let arrivalTime = snap.value["Arrival Time"] as? String
                    let travelMode = snap.value["Travel Mode"] as? String
                    var guestToInsert = Member(name: name!, eta: arrivalTime!, mode: travelMode!)
                    
                    self.members.insert(guestToInsert, atIndex: self.members.count)
                    
                }
            }
            // Update data on cell
            self.tableView.reloadData()
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // Return the number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // A single member
        let member = members[indexPath.row]
        
        // Configure the cell...
        if let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell") as? MemberCell {
            
            // Send the single event to configureCell() in EventCellTableViewCell.
            cell.configureCell(member)
            
            return cell
            
        } else {
            
            return MemberCell()
            
        }
        
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
    
    @IBAction func cancelToMembersViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func addMember(segue:UIStoryboardSegue) {
//        if let addMemberViewController = segue.sourceViewController as? AddMemberViewController {
//            
//            //add the new book to the books array
//            if let member = addMemberViewController.member {
//                members.append(member)
//                
//                //update the tableView
//                let indexPath = NSIndexPath(forRow: members.count-1, inSection: 0)
//                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            }
//        }
    }


}
