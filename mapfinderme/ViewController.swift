//
//  ViewController.swift
//  mapfinderme
//
//  Created by pramono wang on 8/11/16.
//  Copyright © 2016 fnu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    //difference between let and var?
    
    var locationManager =  CLLocationManager()
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        
//        locationManager.delegate = self
//        
        mapView = MKMapView()
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self

        view.addSubview(mapView)
        
        
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    required init(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)!
//        mapView = MKMapView()
//    }
    
    
    
    
    func setCenterOfMapToLocation (location: CLLocationCoordinate2D)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addPinToMapView (item: MKMapItem)
    {
        let annotation = MyAnnotation(coordinate: (item.placemark.location?.coordinate)!, title: item.name!, subtitle: item.phoneNumber!)
        mapView.addAnnotation(annotation)
        //setCenterOfMapToLocation((item.placemark.location?.coordinate)!)
        
    }
    

    func displayAlertWithTitle(title:String, message: String)
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
//    func createLocationManager(startImmediately: Bool)
//    {
//        locationManager = CLLocationManager()
//        
//        if let manager = locationManager {
//            println("Successfully created the location manager")
//            manager.delegate = self
//            if startImmediately
//            {
//                manager.startUpdatingLocation()
//            }
//        }
//    }

    
    
    ////////////////////////////////////////////////////////////////////////////////////
    //info p.list
    //key NSLocationWhenINUseUsageDescription : Testing location services
    ////////////////////////////////////////////////////////////////////////////////////
    
    
    override func viewDidAppear(animated: Bool) {
        //////////////////////////////////////////////////////////////////////////////
        //recipe 9.3
        //////////////////////////////////////////////////////////////////////////////
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus(){
//            case .Authorized:
//                print("authorized")
//                locationManager.startUpdatingLocation()
//                mapView.userTrackingMode = .Follow
//            case .AuthorizedWhenInUse:
//                print("authorized")
//                locationManager.startUpdatingLocation()
            case .Denied:
                displayAlertWithTitle("Not Determined", message: "Location services are not allowed for this app")
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .Restricted:
                displayAlertWithTitle("Restricted", message: "Location Services are not allowed for this app")
            default:
                print("authorized")
                locationManager.startUpdatingLocation()
                mapView.userTrackingMode = .Follow
                mapView.showsUserLocation = true
                
            }
            
        }
        else
        {
            print("Location Services are not enabled")
        }
        
        let serviceType = SLServiceTypeTwitter
        
        if SLComposeViewController.isAvailableForServiceType(serviceType)
        {
            let controller = SLComposeViewController(forServiceType: serviceType)
            controller.setInitialText("Safari is a great browser")
            controller.addURL(NSURL(string: "http://www.twitter.com"))
            controller.completionHandler = {(result: SLComposeViewControllerResult) in print("completed")
            }
            presentViewController(controller, animated: true, completion: nil)
        }
        else
        {
            print("The twitter service is not available")
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print ("The authorization status is changed to: ")
        
        switch CLLocationManager.authorizationStatus(){
        case .Denied:
            print("Denied")
        case .NotDetermined:
            print("Not determined")
        case .Restricted:
            print("Restricted")
        default:
            print ("allowed")
            showUserLocationOnMapView()
        }
    }
    
    func showUserLocationOnMapView()
    {
        mapView.showsUserLocation = true
        
        //keep the center of the map view as the user's location and ajust the map as the user moves
        mapView.userTrackingMode = .Follow
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        displayAlertWithTitle("Failed", message: "Could not get the user's location")
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print ("update location")
        
        mapView.userTrackingMode = .Follow
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurants"
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        request.region = MKCoordinateRegion(center: (userLocation.location?.coordinate)!, span: span)
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler{
            (response: MKLocalSearchResponse?, error: NSError?) in
            
            guard let response = response else
            {
                print ("There are no restaurants nearby ")
                return
            }
            
            for item in response.mapItems
            {
                
                self.addPinToMapView(item)
                
                print("Item name = \(item.name)")
                print("Item phone number = \(item.phoneNumber)")
            }
        }
    }
    
    
    
    func retrieveJsonFromData (data: NSData)
    {
        
        
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            print ("Successfully deserialized...")
            
            if jsonObject is NSDictionary{
                let deserializedDictionary = jsonObject as! NSDictionary
                print ("Deserialized JSON Dictionary = \(deserializedDictionary)")
            }
            else if jsonObject is NSArray{
                let deserializedArray = jsonObject as! NSArray
                print ("Deserialized JSON Array = \(deserializedArray)")
            }
            else
            {
                print ("The deserializer only returns dictionaries or arrays")
            }
        }
        catch let error as NSError {
            print ("Failed to load \(error.localizedDescription)")
        }
        
        
        
        
    }

}

