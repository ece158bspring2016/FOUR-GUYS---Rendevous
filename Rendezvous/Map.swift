//
//  MapRouting.swift
//  Rendezvous
//
//  Created by John Law on 6/6/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

let map = Map()

class Map: UIViewController{

    let locationManager = CLLocationManager()
    var mapView: MKMapView! = MKMapView()
    
    func routing() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()

        
        definesPresentationContext = true

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = dataService.DESTINATION
        print("before")
        request.region = mapView.region
        print("after")
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            
            let request = MKDirectionsRequest()
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: (self.locationManager.location?.coordinate)!, addressDictionary: nil))
            request.destination = MKMapItem(placemark: response.mapItems[0].placemark)
            request.transportType = dataService.desiredMode
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { response, error -> Void in
                if let err = error {
                    
                    print(err.userInfo["NSLocalizedFailureReason"])
                    return
                }
                
                let nf = NSNumberFormatter()
                nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
                nf.maximumFractionDigits = 0

                // Calculate ETA
                let current_route = response!.routes[0]
                let expected_time = current_route.expectedTravelTime
                var expected_time_string: String
                expected_time_string = "ETA: "
                let days = Int(expected_time / (60*60*24))
                let hours = Int(expected_time / (60*60)) % 24
                
                //let expectedArrivalDate = currentDate.dateByAddingTimeInterval(expected_time)
                //let components = calendar.components([ .Hour, .Minute, .Second], fromDate: currentDate)
                
                
                var expectedArrivalDate_string: String = "Arrival: "
                //
                var min = Int(expected_time / 60) % 60
                if (Double(min) != (expected_time / 60) % 60) {
                    min += 1
                }
                if (days > 0) {
                    expected_time_string = expected_time_string.stringByAppendingString("\(days) d ")
                }
                if (hours > 0) {
                    expected_time_string = expected_time_string.stringByAppendingString("\(hours) hr ")
                }
                if (min > 0) {
                    expected_time_string = expected_time_string.stringByAppendingString("\(min) min ")
                }

                let calendar = NSCalendar.currentCalendar()
                let adate = NSDate()
                let components = calendar.components([ .Hour, .Minute, .Second, .Day, .Month, .Year], fromDate: adate)
                
                
                var ahour : Int  = components.hour + hours
                var aminutes : Int = components.minute + min
                let amonth : Int = components.month
                let ayear : Int = components.year
                var aday  = components.day + days
                if (aminutes > 60)
                {
                    aminutes = aminutes - 60
                    ahour = ahour + 1
                }
                while (ahour >= 24)
                {
                    ahour = ahour - 24
                    
                    aday = aday + 1
                }
                
                let arrival_time: String!
                if (ahour > 12){
                    arrival_time = "\(ahour-12):\(aminutes) PM  \(amonth)-\(aday)-\(ayear) "
                }
                else {
                    arrival_time = "\(ahour):\(aminutes) AM  \(amonth)-\(aday)-\(ayear) "
                }
                
                expectedArrivalDate_string = expectedArrivalDate_string.stringByAppendingString(arrival_time)
                
                // Save arrival time for current user
                dataService.CURRENT_USER_ARRIVAL_TIME = arrival_time
                
                print(arrival_time)
                
                // Reference to arrival time field of current event
                let timeRef = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/\(dataService.CURRENT_SELECTED_EVENT_UID)/Guests/\(dataService.CURRENT_USER_UID)").childByAppendingPath("Arrival Time")
                
                // Update arrival time
                timeRef.setValue(dataService.CURRENT_USER_ARRIVAL_TIME)

            }

        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        // Create another annotation for the map.
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = newLocation.coordinate
        
//        // Add to locations array
//        locations.append(annotation)
//        
//        // Remove values if the array is too big
//        while locations.count > 100 {
//            let annotationToRemove = locations.first!
//            locations.removeAtIndex(0)
//            
//            // Also remove from the map
//            mapView.removeAnnotation(annotationToRemove)
//        }
        
        if UIApplication.sharedApplication().applicationState == .Active {
            print("APP IS ACTIVE")
            //mapView.showAnnotations(locations, animated: true)
        } else {
            //NSLog("App is backgrounded. New location is %@", newLocation)
            print("APP IS BACKGROUNDED")
        }
    }

}


extension Map : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}
