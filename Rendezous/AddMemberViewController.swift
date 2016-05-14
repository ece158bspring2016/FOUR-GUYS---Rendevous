//
//  AddMemberViewController.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit

class AddMemberViewController: UITableViewController {
    var member:Member?
    
    @IBOutlet weak var email_textfield: UITextField!

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
            member = Member(name: email_textfield.text!, eta: "Pending")
        }
        print(segue.identifier)
    }    
}
