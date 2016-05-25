//
//  Event.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class Event {
    
    // Firebase references
    private var _baseRef: Firebase!
    private var _eventKey: String!
    
    private var event_name: String!
    private var sender: String!
    
    var eventKey: String {
        return _eventKey
    }
    
    var eventName: String {
        return event_name
    }
    
    var senderName: String {
        return sender
    }
    
    // Initialize a new event
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._eventKey = key
        
        print("THE KEY IS::::::::::::::::::::")
        print(key)
        print("END KEY:::::::::::::::::::::::")
        
        if let event = dictionary["EventName"] as? String {
            self.event_name = event
        }
        
        if let eventStarter = dictionary["Sender"] as? String {
            self.sender = eventStarter
        }

        // Assign above properties to their key
        self._baseRef = DataService.dataService.EVENT_REF.childByAppendingPath(self._eventKey)

    }
}