//
//  AddMemberViewController.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class AddMemberViewController: UITableViewController {
    var member:Member?
    
    @IBOutlet weak var email_textfield: UITextField!
    var currentUser = ""
    var inviteeUID = ""
    var eventUID = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            email_textfield.becomeFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddMember" {
            member = Member(name: email_textfield.text!, eta: "Pending", mode: "")
            
            self.eventUID = dataService.selectedEvent
            
            // Look for user with entered phone number
            dataService.USERS_REF.queryOrderedByChild("PhoneNumber").queryEqualToValue(member!.name).observeEventType(.ChildAdded, withBlock: { snapshot in
                
                self.inviteeUID = snapshot.key
                self.eventUID = dataService.CURRENT_SELECTED_EVENT_UID
                
                // Add event to invitee's guest list
                dataService.BASE_REF.childByAppendingPath("USERS/\(self.inviteeUID)/EVENTS/\(self.eventUID)").setValue("Pending")
                
                // Add invitee to event's guest list
                dataService.USERS_REF.queryOrderedByKey().queryEqualToValue(self.inviteeUID).observeEventType(.ChildAdded, withBlock: { snapshot2 in
                    
                    let name = snapshot2.value["Name"] as? String
            
                    let invitedGuest = ["Arrival Time": "Pending", "Name": name!, "Travel Mode": ""]
                    
                    // Append invitee to the event's guest list on Firebase
                    dataService.BASE_REF.childByAppendingPath("EVENTS/\(self.eventUID)/Guests/\(self.inviteeUID)").setValue(invitedGuest)
                    
                    // Reference to event status for invited user
                    let eventStatusRef = Firebase(url: "https://rend-ezvous.firebaseio.com/USERS/\(self.inviteeUID)/EVENTS/\(dataService.CURRENT_SELECTED_EVENT_UID)")
                    
                    // Update event status
                    eventStatusRef.setValue("Pending")


                })
            })
        }
        print(segue.identifier)
    }
    
}
