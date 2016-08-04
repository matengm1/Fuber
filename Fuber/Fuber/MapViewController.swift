//
//  MapViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/12/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import MapKit
import Firebase
import UIKit
import CoreLocation
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startLocationSearch: UISearchBar!
    @IBOutlet weak var endLocationSearch: UISearchBar!
    @IBAction func RouteDestination(sender: UIButton) {
        BeginMapping()
    }
    
    let locationManager = CLLocationManager()
    var location : String?
    var locationCLLocation: CLLocation?
    var locationPFGeoPoint : PFGeoPoint?
    let userQuery = PFUser.query()!
    var userLocation : CLLocation?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        
        
        
        
//        location = "921 Newell Rd, Palo Alto, CA"
        print(userLocation, "weeeeeeee")
    }
    
    func BeginMapping() {
//        let geocoder:CLGeocoder = CLGeocoder();
//        geocoder.geocodeAddressString(location!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//            if placemarks?.count > 0 {
//                let topResult:CLPlacemark = placemarks![0];
//                let placemark: MKPlacemark = MKPlacemark(placemark: topResult);
//                
//                var region: MKCoordinateRegion = self.mapView.region;
//                region.center = (placemark.location?.coordinate)!;
//                region.span.longitudeDelta /= 8.0;
//                region.span.latitudeDelta /= 8.0;
//                self.mapView.setRegion(region, animated: true);
//                self.mapView.addAnnotation(placemark);
//                //                self.drawRoute(placemark)
//                var timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("drawRoute:"), userInfo: placemark, repeats: true)
//            }
//        }
        
        
        
        print(userLocation)
//        let placemark: MKPlacemark = MKPlacemark(placemark: userLocation as! CLPlacemark)
        var region: MKCoordinateRegion = self.mapView.region;
        region.center = userLocation!.coordinate;
        region.span.longitudeDelta /= 8.0;
        region.span.latitudeDelta /= 8.0;
        self.mapView.setRegion(region, animated: true);
        var placemark = MKPlacemark(coordinate: userLocation!.coordinate, addressDictionary: nil)
        self.mapView.addAnnotation(placemark);
//                        self.drawRoute(placemark)
        var altTimer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("drawRoute:"), userInfo: placemark, repeats: false)
        var timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("drawRoute:"), userInfo: placemark, repeats: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations, var locations: [CLLocation])
//    {
//        var location: CLLocation = locations.last!
//        if location.horizontalAccuracy < 0 {
//            return
//        }
//        locations.append(location)
//        var count: Int = locations.count
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//        
//        self.mapView.setRegion(region, animated: true)
//        
////        self.locationManager.stopUpdatingLocation()
//        
//        if count > 1 {
//            var coordinates: [CLLocationCoordinate2D]
//            for i in 0 ..< count {
//                coordinates[i] = (locations[i] as! CLLocation).coordinate
//            }
//            var oldPolyline: MKPolyline = polyline
//            polyline = MKPolyline.polylineWithCoordinates(coordinates, count: count)
//            self.mapView.addOverlay(polyline)
////            if oldPolyline != nil {
//                self.mapView.removeOverlay(oldPolyline)
////            }
//        }
//    }
//    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
//    var polylines: [MKPolyline] = []
//    func drawRoute(destinationPlacemark: MKPlacemark) {
    func drawRoute(timer: NSTimer) {

//        if polylines.count != 0 {
//            self.mapView.removeOverlays(self.mapView.overlays)
//        }
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: timer.userInfo!.coordinate.latitude, longitude: timer.userInfo!.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Automobile
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
//                print("A")
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        var currentLocation = CLLocation!() {
            didSet {
                if currentLocation != nil {
                    print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                }
            }
        }
        currentLocation = locationManager.location
        
//        self.locationPFGeoPoint = PFGeoPoint(location: currentLocation)
//        print(self.locationPFGeoPoint!)
//        PFUser.currentUser()!
        PFGeoPoint.geoPointForCurrentLocationInBackground { (loc, error) in
            PFUser.query()!.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId!)!, block: { (currentUser, error) in
                currentUser!["location"] = loc
                currentUser!.saveInBackground()
            })
        }
    }
    
    
    
    @IBAction func pickPlace(sender: UIBarButtonItem) {
//        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
//        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
//        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
//        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        let config = GMSPlacePickerConfig(viewport: viewport)
//        let placePicker = GMSPlacePicker(config: config)
//        
//        placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let place = place {
//                print("Place name \(place.name)")
//                print("Place address \(place.formattedAddress)")
//                print("Place attributions \(place.attributions)")
//            } else {
//                print("No place selected")
//            }
//        })
    }

    
    
    
    
//    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
}