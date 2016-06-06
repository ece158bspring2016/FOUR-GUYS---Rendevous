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
    private var event_address: String!
    
    private var destination: String!
    private var arrival_time: String!
    
    private var selectedEvent: String!
    private var event_Status: String!
    
    var eventsList:[Event] = []
    
    var eventKey: String {
        return _eventKey
    }
    
    var eventName: String {
        return event_name
    }
    
    var senderName: String {
        return sender!
    }
    
    var eventAddress: String {
        return event_address
    }
    
    var eventStatus: String {
        get {
            return self.event_Status
        }
        set(e_S) {
            self.event_Status = e_S
        }
    }

    
    var eventsArray: [Event] {
        get {
            return self.eventsList
        }
        set(e_A) {
            self.eventsList = e_A
        }
    }
        
    
    // Initialize a new event
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._eventKey = key
        
        print("DICTIONARY")
        print(dictionary)
        print("END DICTIONARY")
        
        if let event = dictionary["Destination"] as? String {
            self.event_name = event
        }
        
        if let eventStarter = dictionary["Starter"] as? String {
            self.sender = eventStarter
        }

        if let address = dictionary["Address"] as? String {
            self.event_address = address
        }
        
        //if let status = dictionary[

        // Assign above properties to their key
        self._baseRef = dataService.EVENT_REF.childByAppendingPath(self._eventKey)

    }
    
    init(destination: String, arrival_time: String, address: String) {
        self.destination = destination
        self.arrival_time = arrival_time
        self.event_address = address
    }
    
    func startEvent() {
        let event:Dictionary<String, AnyObject> = ["Address": self.event_address, "Destination":self.destination, "Starter": user_info.getName, "Guests": [user_info.getUID: ["Arrival Time": self.arrival_time, "Name": user_info.getName]]]
        dataService.createNewEvent(event)
    }
        
}