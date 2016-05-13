//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController : UIViewController {
    
    var selectedPin:MKPlacemark? = nil
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address_label: UILabel!
    //@IBOutlet weak var departure_time_label: UILabel!
    @IBOutlet weak var arrival_time_label: UILabel!
    @IBOutlet weak var distance_label: UILabel!
    @IBOutlet weak var eta_label: UILabel!
    @IBOutlet weak var background_label: UILabel!
    @IBOutlet weak var start_button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        address_label.text = nil
        //departure_time_label.text = nil
        arrival_time_label.text = nil
        distance_label.text = nil
        eta_label.text = nil
        background_label.backgroundColor = nil
        start_button.hidden = true

    }
    
    /*
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }*/
}

extension ViewController : CLLocationManagerDelegate {
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

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
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

extension ViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        
        //Not letting user go to apple's map
        //let smallSquare = CGSize(width: 30, height: 30)
        //let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        //button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        //button.addTarget(self, action: #selector(ViewController.getDirections), forControlEvents: .TouchUpInside)
        //pinView?.leftCalloutAccessoryView = button
        
        //Update the info
        background_label.backgroundColor = UIColor.groupTableViewBackgroundColor()

        let request = MKDirectionsRequest()

        //print(locationManager.location)
        //print(MKMapItem.mapItemForCurrentLocation())
        //let current_location = MKPlacemark.init(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil)
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (locationManager.location?.coordinate)!, addressDictionary: nil))
        request.destination = MKMapItem(placemark: selectedPin!)
        request.transportType = MKDirectionsTransportType.Automobile
    
        let directions = MKDirections(request: request)
        directions.calculateETAWithCompletionHandler { response, error -> Void in
            if let err = error {
                //self.eta_label.text = err.userInfo["NSLocalizedFailureReason"] as? String
                print(err.userInfo["NSLocalizedFailureReason"])
                return
            }
            
            let nf = NSNumberFormatter()
            nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
            nf.maximumFractionDigits = 0
            
            //print(response!.expectedTravelTime)
            //print(response!.expectedDepartureDate.year)
            //print(response!.expectedArrivalDate)
            //print(response!.distance)
            
            self.address_label.text = request.destination?.name
            
            // Calculate ETA
            let expected_time = response!.expectedTravelTime
            var expected_time_string: String
            expected_time_string = "ETA: "
            let days = Int(expected_time / (60*60*24))
            let hours = Int(expected_time / (60*60)) % 24
            var min = Int(expected_time / 60) % 60
            if (Double(min) != (expected_time / 60) % 60) {
                min += 1
            }
            if (days > 0) {
                expected_time_string = expected_time_string.stringByAppendingString("\(days)d ")
            }
            if (hours > 0) {
                expected_time_string = expected_time_string.stringByAppendingString("\(hours)hr ")
            }
            if (min > 0) {
                expected_time_string = expected_time_string.stringByAppendingString("\(min)min ")
            }
            self.eta_label.text = expected_time_string

            //self.departure_time_label.text = "Departure Time: \(response!.expectedDepartureDate)"
            self.arrival_time_label.text = "Arrival Time: \(response!.expectedArrivalDate)"
            self.distance_label.text = "Distance: \(Float(response!.distance) * 0.000621371192) mile"
            self.start_button.hidden = false
        }

        return pinView
    }
}