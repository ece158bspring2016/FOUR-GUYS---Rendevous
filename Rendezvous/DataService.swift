//
//  DataService.swift
//  Rendezvous
//
//  Created by David Serrano on 5/21/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    static let BASE_URL = "https://rendezvous-9f2a3.firebaseio.com/"
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _EVENT_REF = Firebase(url: "\(BASE_URL)/EVENTS/")
    //private var _CURRENT_EVENT_REF = Firebase(url: "\(BASE_URL)/EVENTS/")
    //private var _CURRENT_EVENT_REF = Firebase(url: CURRENT_EVENT_URL)

    
    var currentEventID = ""
    var destination = ""

    
    private var CURRENT_EVENT_URL = ""
    
    
    // Get base reference
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    // Get event reference
    var EVENT_REF: Firebase {
        return _EVENT_REF
    }
    
    // Get current user
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    // Get/set destination when creating an event
    var DESTINATION: String {
        get {
            return destination
        }
        set (dest) {
            self.destination = dest
        }
    }
    
    // Path to current event
    var CURRENT_EVENT_REF_URL: String {
        get {
            return CURRENT_EVENT_URL
        }
        set (current_event_ref) {
            self.CURRENT_EVENT_URL = "(https://rendezvous-9f2a3.firebaseio.com/EVENTS/\(currentEventID)/"
        }
    }
    
    func createNewEvent(event: Dictionary<String, AnyObject>) {
        
        // Create new event and give it a unuique ID
        let firebaseNewEvent = EVENT_REF.childByAutoId()
        
        // Get unique ID
        currentEventID = firebaseNewEvent.key
        
        // Save event to firebase
        firebaseNewEvent.setValue(event)
    }
    
}
