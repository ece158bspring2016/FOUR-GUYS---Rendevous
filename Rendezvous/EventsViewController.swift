//
//  EventsViewController.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class EventsViewController: UITableViewController {
    
    // Define events array
    var events:[Event] = []
    //var currentEventName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Current user's events
        dataService.CURRENT_USER_EVENTS_REF.observeEventType(.Value, withBlock: { snapshot in
            
            self.events = []
            
            // Snapshot of user's events
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    //  Get full event data (destination, starter for this scene)
                    dataService.EVENT_REF.queryOrderedByKey().queryEqualToValue(snap.key).observeEventType(.ChildAdded, withBlock: { snapshot2 in
                        if let postDictionary = snapshot2.value as? Dictionary<String, AnyObject> {
                            let key = snapshot2.key
                            let eventToInsert = Event(key: key, dictionary: postDictionary)

                            self.events.insert(eventToInsert, atIndex:0)
                        }
                        
                        // Update data on cell
                        self.tableView.reloadData()

                    })
                }
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // A single event
        let event = events[indexPath.row]

        // Configure the cell...
        if let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as? EventCellTableViewCell {
            
            // Send the single event to configureCell() in EventCellTableViewCell.
            
            cell.configureCell(event)
            
            return cell
            
        } else {
            
            return EventCellTableViewCell()
            
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

}
