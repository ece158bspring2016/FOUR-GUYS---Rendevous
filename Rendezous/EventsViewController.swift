//
//  EventsViewController.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Firebase

class EventsViewController: UIViewController {
    
    //var events:[Event] = event_data
    var events:[Event] = []
    var events_data:[Event] = []

    
    // Firebase reference
    let ref = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/event1")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Event.populateEvents()
        
        // Do any additional setup after loading the view.
        
        // Attach a closure to read the data when there are updates
//        ref.observeEventType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//            print(snapshot.value.objectForKey("EventName"), snapshot.value.objectForKey("Sender"))
//            
//            self.events.append(Event(event_name:"\(snapshot.value.objectForKey("EventName"))?", sender: "\(snapshot.value.objectForKey("Sender"))"))
//            
//            var whatsHere = "\(snapshot.value.objectForKey("EventName"))!"
//
//            }, withCancelBlock: { error in
//                print(error.description)
//            
//        })
        
        self.populateEvents()
        //events = self.populateEvents()
        
        //event_data.append(Event(event_name:"\(snapshot.value.objectForKey("EventName"))?", sender: "\(snapshot.value.objectForKey("Sender"))?"))
        events = event_data

        
        print("EVENT SHIT")
        print(events.first?.event_name)
        print("End Events Shit")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Return the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        
        // Configure the cell...
        
        let event = events[indexPath.row] as Event
        cell.event = event
        
        return cell
    }

    func populateEvents() {
        
        var temp: [Event] = []
//
//        ref.observeEventType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//            print(snapshot.value.objectForKey("EventName"), snapshot.value.objectForKey("Sender"))
//            
//            temp.append(Event(event_name:"\(snapshot.value.objectForKey("EventName"))?", sender: "\(snapshot.value.objectForKey("Sender"))"))
//            
//            var whatsHere = "\(snapshot.value.objectForKey("EventName"))"
//            
//            }, withCancelBlock: { error in
//                print(error.description)
//                
//        })
//        
//        print("TEMP:")
//        print(temp.first)
//        
//        return temp
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
            } else {
                //init myArray var and then fill with values
                //for child in snapshot.children {
                self.events_data.append(Event(event_name:"\(snapshot.value.objectForKey("EventName"))", sender: "\(snapshot.value.objectForKey("Sender"))"))
                    print("\(snapshot.value.objectForKey("EventName"))")
                //}
                
                //now that we have filled the array, we can generate
                //  random numbers and pull quotes from it
                
                print("Inside Loop")
                print(self.events_data.first?.event_name!)
                print("End Inside Loop")

            }
        })
        
        print(self.events_data)
        
//        //update the tableView
//        let indexPath = NSIndexPath(forRow: events.count-1, inSection: 0)
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)



        //return temp
        
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
