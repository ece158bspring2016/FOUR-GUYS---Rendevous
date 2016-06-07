//
//  DataService.swift
//  Rendezvous
//
//  Created by David Serrano on 5/21/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import Foundation
import Firebase
import MapKit

let dataService = DataService()

class DataService {

    static let BASE_URL = "https://rend-ezvous.firebaseio.com/"
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _EVENT_REF = Firebase(url: "\(BASE_URL)/EVENTS/")
    private var _USERS_REF = Firebase(url: "\(BASE_URL)/USERS/")


    
    var currentEventID = ""
    var destination = ""
    var currentUserName = ""
    var currentUserUID = ""
    var currentEventName = ""
    var selectedEvent = ""
    var arrivalTime = ""
    var desiredMode : MKDirectionsTransportType = MKDirectionsTransportType.Automobile
    var desiredModeString = "Automobile"
    var eventStorage:[Event] = []
    

    
    private var CURRENT_EVENT_URL = ""
    
    
    // Get base reference
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    // Get event reference
    var EVENT_REF: Firebase {
        return _EVENT_REF
    }
    
    // Get event reference
    var USERS_REF: Firebase {
        return _USERS_REF
    }
    
    var CURRENT_SELECTED_EVENT_UID: String {
        get {
            return selectedEvent
        }
        set (currentSelected) {
            self.selectedEvent = currentSelected
        }
    }
    
    var CURRENT_SELECTED_EVENT_GUESTS_REF: Firebase {
        
        let currentUserEvents = Firebase(url: "\(BASE_REF)").childByAppendingPath("EVENTS").childByAppendingPath(CURRENT_SELECTED_EVENT_UID).childByAppendingPath("Guests")
        
        return currentUserEvents!
    }

    var CURRENT_EVENT_NAME: String {
        get {
            return currentEventName
        }
        set (currentEventName) {
            self.currentEventName = currentEventName
        }
    }
    
    var CURRENT_USER_ARRIVAL_TIME: String {
        get {
            return arrivalTime
        }
        set (current_User_Time) {
            self.arrivalTime = current_User_Time
        }
    }


    var CURRENT_USER_EVENTS_REF: Firebase {
        
        let currentUserEvents = Firebase(url: "\(BASE_REF)").childByAppendingPath("USERS").childByAppendingPath(CURRENT_USER_UID).childByAppendingPath("EVENTS")
        
        return currentUserEvents!
    }
    
    var CURRENT_USER_NAME: String {
        get {
            return currentUserName
        }
        set (currUser) {
            self.currentUserName = currUser
        }
    }

    
    // Get current user
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var CURRENT_USER_UID: String {
        get {
            return currentUserUID
        }
        set (currUserUID) {
            self.currentUserUID = currUserUID
        }
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
            self.CURRENT_EVENT_URL = "(https://rend-ezvous.firebaseio.com/EVENTS/\(currentEventID)/"
        }
    }
    
    func createNewEvent(event: Dictionary<String, AnyObject>) {
        
        // Create new event and give it a unuique ID
        let firebaseNewEvent = EVENT_REF.childByAutoId()
        
        // Get unique ID
        currentEventID = firebaseNewEvent.key
        
        // Save event to firebase
        firebaseNewEvent.setValue(event)
        
        // Set the current event id
        dataService.CURRENT_SELECTED_EVENT_UID = currentEventID
        
        // Append event to user profile on Firebase
        self._BASE_REF.childByAppendingPath("USERS/\(CURRENT_USER_UID)/EVENTS/\(currentEventID)").setValue("Accepted")
    }
    
    func removeEvent(event_ID: String) {
        // Delete event from user's event list (Firebase)
        let userRef = Firebase(url: "https://rend-ezvous.firebaseio.com/USERS/\(dataService.CURRENT_USER_UID)/EVENTS/\(event_ID)")
        userRef.removeValue()
        
        // Delete user from event's guest list (Firebase)
        let eventRef = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/\(event_ID)/Guests/\(dataService.CURRENT_USER_UID)")
        eventRef.removeValue()
    }
}
