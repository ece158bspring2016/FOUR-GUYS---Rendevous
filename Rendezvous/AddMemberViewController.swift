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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //currentUser = DataService.dataService.CURRENT_USER_REF as String

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Get current user to locate event starter and event
//        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
//            
//            let currentUser = snapshot.value.objectForKey("username") as! String
//            
//            print("Username: \(currentUser)")
//            self.currentUser = currentUser
//            }, withCancelBlock: { error in
//                print(error.description)
//        })

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
        
        let memberToAdd = email_textfield.text
        
        if segue.identifier == "AddMember" {
            member = Member(name: email_textfield.text!, eta: "Pending")
            
            let newEvent: Dictionary<String, AnyObject> = [
                "EventName": DataService.dataService.DESTINATION,
                "Sender"   : currentUser,
                "Guests"   : ""
                ]
            
            // Call to save to firebase
            DataService.dataService.createNewEvent(newEvent)
            
            print("event path is ")
            //print(DataService.dataService.CURRENT_EVENT_REF)

            
        }
        
        print(segue.identifier)
    }    
}
