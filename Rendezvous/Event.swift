//
//  Event.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

var cur_event: Event!

class Event {
    
    // Firebase references
    private var _baseRef: Firebase!
    private var _eventKey: String!
    
    private var event_name: String!
    private var sender: String!
    private var eventAddress: String!
    
    private var destination: String!
    private var arrival_time: String!
    
    var eventKey: String {
        return _eventKey
    }
    
    var eventName: String {
        return event_name
    }
    
    var senderName: String {
        return sender!
    }
    
    // Initialize a new event
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._eventKey = key
        
        if let event = dictionary["Destination"] as? String {
            self.event_name = event
        }
        
        if let eventStarter = dictionary["Starter"] as? String {
            self.sender = eventStarter
        }
        
        // Assign above properties to their key
        self._baseRef = dataService.EVENT_REF.childByAppendingPath(self._eventKey)

    }
    
    init(destination: String, arrival_time: String, address: String) {
        self.destination = destination
        self.arrival_time = arrival_time
        self.eventAddress = address
    }
    
    func startEvent() {
        let event:Dictionary<String, AnyObject> = ["Address": self.eventAddress, "Destination":self.destination, "Starter": user_info.getName, "Guests": [user_info.getUID: ["Arrival Time": self.arrival_time, "Name": user_info.getName]]]
        dataService.createNewEvent(event)
    }
        
}