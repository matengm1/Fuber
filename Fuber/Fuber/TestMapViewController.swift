//
//  TestMapViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/12/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import MapKit
import UIKit
import GoogleMaps
import GoogleMapsDirections
//import GooglePlaces

class TestMapViewController: UIViewController {
    
    var locManagerOp: CLLocationManager?
    var cameraOp: GMSCameraPosition?
    var mapViewOp: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locManagerOp = CLLocationManager()
        cameraOp = GMSCameraPosition.cameraWithLatitude((locManagerOp!.location?.coordinate.latitude)!, longitude: (locManagerOp!.location?.coordinate.longitude)!, zoom: 6)
        mapViewOp = GMSMapView.mapWithFrame(self.view.bounds, camera: cameraOp!)
        mapViewOp!.myLocationEnabled = true
        self.view!.insertSubview(mapViewOp!, atIndex: 0)
        mapViewOp!.myLocationEnabled = true
        
        
        let origin = GoogleMapsDirections.Place.StringDescription(address: "Davis Center, Waterloo, Canada")
        let destination = GoogleMapsDirections.Place.StringDescription(address: "Conestoga Mall, Waterloo, Canada")
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.OK else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage)
                return
            }
            
            // Use .result or .geocodedWaypoints to access response details
            // response will have same structure as what Google Maps Directions API returns
            print("it has \(response?.routes.count ?? 0) routes")
        }
        
        
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
        {
            print("Errors: " + error.localizedDescription)
        }
        
        placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
            } else {
                print("No place selected")
            }
        })
//        var path = GMSPath.pathFromEncodedPath(encodedPath(CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), )
        
//        var singleLine: GMSPolyline = GMSPolyline.polylineWithPath(path)
//        singleLine.strokeWidth = 7
//        singleLine.strokeColor = UIColor.greenColor()
//        singleLine.map = mapView
    }
    
    @IBAction func SetLocationTouched(sender: UIButton) {
        let currentTitle = sender.currentTitle
        let currentLocLat = (locManagerOp!.location?.coordinate.latitude)!
        let currentLocLong = (locManagerOp!.location?.coordinate.longitude)!
        let marker = GMSMarker()
        switch currentTitle! {
        case "Set Location":
            print("Setting location")
            marker.position = CLLocationCoordinate2DMake(currentLocLat, currentLocLong)
            print(mapViewOp!.myLocation)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapViewOp!
            sender.setTitle("Clear Location", forState: UIControlState.Normal)
            break
        case "Clear Location":
            print("Clearing Location")
//            marker.map = nil
            mapViewOp?.clear()
            print(marker.title)
            sender.setTitle("Set Location", forState: UIControlState.Normal)
            break
        default: break
        }
    }
    
    @IBAction func DrawRoute(sender:UIButton) {
        let cameraPosition: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(18.5203, longitude: 73.8567, zoom: 12)
        self.mapViewOp = GMSMapView.mapWithFrame(CGRectZero, camera: cameraPosition)
        self.mapViewOp!.myLocationEnabled = true
        let marker: GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(18.5203, 73.8567)
//        marker.icon = UIImage(named: "aaa.png")!
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        marker.map = mapViewOp
        let path: GMSMutablePath = GMSMutablePath(path: GMSPath())
        path.addCoordinate(CLLocationCoordinate2DMake(18.520.doubleValue, 73.856.doubleValue))
        path.addCoordinate(CLLocationCoordinate2DMake(16.7.doubleValue, 73.8567.doubleValue))
        let rectangle: GMSPolyline = GMSPolyline(path: GMSPath())
        rectangle.strokeWidth = 2.0
        rectangle.map = mapViewOp
        self.view = mapViewOp
    }
}