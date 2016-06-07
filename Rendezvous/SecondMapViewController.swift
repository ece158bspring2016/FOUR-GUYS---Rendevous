//
//  SecondMapViewController.swift
//  Rendezvous
//
//  Created by Anh Mai on 6/4/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleMapSearch2 {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class SecondMapViewController : UIViewController {
    var handleMapSearchDelegate:HandleMapSearch? = nil

    var selectedPin:MKPlacemark? = nil

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var background_label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distance_label: UILabel!
    @IBOutlet weak var arrival_time_label: UILabel!
    @IBOutlet weak var eta_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        definesPresentationContext = true
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = dataService.DESTINATION
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.dropPinZoomIn(response.mapItems[0].placemark)
        }

        
    }
    
    @IBAction func backToMapViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func acceptPressed(sender: UIButton) {
        print(sender.titleLabel?.text!)
        
        // Reference to arrival time field of current event
        let timeRef = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/\(dataService.CURRENT_SELECTED_EVENT_UID)/Guests/\(dataService.CURRENT_USER_UID)").childByAppendingPath("Arrival Time")
        
        // Reference to event status for current user
        let eventStatusRef = Firebase(url: "https://rend-ezvous.firebaseio.com/USERS/\(dataService.CURRENT_USER_UID)/EVENTS/\(dataService.CURRENT_SELECTED_EVENT_UID)")
        
        let travelModeRef = Firebase(url: "https://rend-ezvous.firebaseio.com/EVENTS/\(dataService.CURRENT_SELECTED_EVENT_UID)/Guests/\(dataService.CURRENT_USER_UID)").childByAppendingPath("Travel Mode")
                
        // Update arrival time
        timeRef.setValue(dataService.CURRENT_USER_ARRIVAL_TIME)
        
        // Update event status
        eventStatusRef.setValue("Accepted")
        
        // Update travel mode for guest
        travelModeRef.setValue(dataService.desiredModeString)
        
        //self.performSegueWithIdentifier("inProgressSegue", sender: nil)

    }
    
    @IBAction func modeofTravel(sender: UISegmentedControl) {
        var modes : [MKDirectionsTransportType] = [
            MKDirectionsTransportType.Automobile,
            MKDirectionsTransportType.Walking,
            MKDirectionsTransportType.Transit]
        
        var modeString : [String] = [
            "Automobile",
            "Walking",
            "Transit"]
            
        dataService.desiredMode = modes[sender.selectedSegmentIndex]
        
        dataService.desiredModeString = modeString[sender.selectedSegmentIndex]
            
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = dataService.DESTINATION
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.dropPinZoomIn(response.mapItems[0].placemark)
        }
    }
    
    
    
    
}

extension SecondMapViewController : CLLocationManagerDelegate {
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

extension SecondMapViewController: HandleMapSearch2 {
    func dropPinZoomIn(placemark:MKPlacemark){
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension SecondMapViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        
        background_label.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil))
        request.destination = MKMapItem(placemark: selectedPin!)
        request.transportType = dataService.desiredMode
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { response, error -> Void in
            if let err = error {
                
                print(err.userInfo["NSLocalizedFailureReason"])
                
                let alert = UIAlertController (title :"Route Failed",
                    message: "Route cannot be determined",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                    print("OK")
                }
                
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                dataService.desiredMode = MKDirectionsTransportType.Automobile
                
                dataService.desiredModeString = "Automobile"

                return
            }
            
            let nf = NSNumberFormatter()
            nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
            nf.maximumFractionDigits = 0
            
            let destination: String = (request.destination?.name)!
            
            // Extract and build destination address
            let address1 = (self.selectedPin?.subThoroughfare)! + " " + (self.selectedPin?.thoroughfare)! + ", " + (self.selectedPin?.locality)! + ", "
            let address2 = (self.selectedPin?.administrativeArea)! + " " + (self.selectedPin?.postalCode)!
            let address = address1 + address2
            
            self.address_label.text = dataService.currentEventName
            
            // Calculate ETA
            let current_route = response!.routes[0]
            let expected_time = current_route.expectedTravelTime
            var expected_time_string: String
            expected_time_string = "ETA: "
            let days = Int(expected_time / (60*60*24))
            let hours = Int(expected_time / (60*60)) % 24
            
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
            var ampm = ""
            if (ahour >= 12) {
                ampm = "PM"
                if (ahour != 12) {
                    ahour -= 12
                }
            }
            else {
                ampm = "AM"
            }
            
            var hour = ""
            
            if (ahour < 10) {
                hour = "0\(ahour)"
            }
            else {
                hour = "\(ahour)"
            }
            
            var minute = ""
            
            if (aminutes < 10) {
                minute = "0\(aminutes)"
            }
            else {
                minute = "\(aminutes)"
            }
            
            let arrival_time: String!
            arrival_time = hour + ":" + minute + " " + ampm + " \(amonth)-\(aday)-\(ayear) "

            expectedArrivalDate_string = expectedArrivalDate_string.stringByAppendingString(arrival_time)
            
            // Save arrival time for current user
            dataService.CURRENT_USER_ARRIVAL_TIME = arrival_time

            
            self.eta_label.text = expected_time_string
            member_data[0].eta = expected_time_string
            
            self.arrival_time_label.text = expectedArrivalDate_string
            self.distance_label.text = "Distance: \(Float(round(current_route.distance * (0.000621371192*1000)/1000))) mile(s)"
            
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(current_route.polyline, level: MKOverlayLevel.AboveRoads)
            
            cur_event = Event.init(destination: destination, arrival_time: arrival_time, address: address)
        }
        
        return pinView
    }
    
    // Give colors to the polyline
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineOverlay = overlay as? MKPolyline
        let render = MKPolylineRenderer(polyline: polylineOverlay!)
        render.strokeColor = UIColor.blueColor()
        return render
        
    }

}