//
//  Event.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
//import Firebase

var event_data = [Event(event_name:"Kanye West's Birgdsgsthday", sender: "Kanye West")]


// Firebase reference
//let ref = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/event1")
//
//
//func populateEvents() {
//    
//    // Do any additional setup after loading the view.
//    
//    // Attach a closure to read the data when there are updates
//    ref.observeEventType(.Value, withBlock: { snapshot in
//        print(snapshot.value)
//        print(snapshot.value.objectForKey("Sender")!)
//        
//        var event_data = [Event(event_name:"\(snapshot.value.objectForKey("EventName"))", sender: "\(snapshot.value.objectForKey("Sender"))")]
//        
//        }, withCancelBlock: { error in
//            print(error.description)
//            
//    })

//    var event_data = [Event(event_name:"\(snapshot.value)", sender: nil)]
    
    



// TODO
//var event_data = [Event(event_name:"\(ref.getValue())", sender: nil)]

struct Event {
    var event_name: String?
    var sender: String?
    
    init(event_name: String?, sender: String?) {
        self.event_name = event_name
        self.sender = sender
        
        //print("Adding %s", event_name)
    }
}