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
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startLocationSearch: UISearchBar!
    @IBOutlet weak var endLocationSearch: UISearchBar!
    @IBAction func RouteDestination(sender: UIButton) {
        BeginMapping()
        
    }
    @IBAction func RequestPickup(sender: AnyObject) {
        RequestingPickup()
    }
    @IBOutlet weak var menuView: UIView!
    @IBAction func ExitButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToGroupSelectorVIewController", sender: self)
    }
    
    let locationManager = CLLocationManager()
    var location : String?
    var locationCLLocation: CLLocation?
    var locationPFGeoPoint : PFGeoPoint?
    let userQuery = PFUser.query()!
    var userLocation : CLLocation?
    var group : PFObject?
    var placemark : MKPlacemark?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        // self.menuView.center = CGPointMake(150, 150)
        print(group)
        print(group!["isRequesting"], "ASDLKJ:SLKDJA:LSKDJAS:DKJS:LKDJAS:LDKJASDKL:ASD::HFLKFGLEHGLJHEF")
        if (!(group!["isRequesting"] as! Bool)) {
            self.menuView.center.y -= view.bounds.height
        }
    
//        self.menuView.center.y = 40

//        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
//            var menuTopFrame = self.menuView.frame
//            self.menuView.center = CGPointMake(150, 150)
//            self.menuView.frame = menuTopFrame
//            self.menuView.layoutIfNeeded()
//            }, completion: { finished in
//                print("Basket doors opened!")
//        })
        let groups = PFQuery(className: "GroupsList")
        groups.getObjectInBackgroundWithId((group?.objectId)!) { (currentGroup, error) in
            print(currentGroup!["isRequesting"] as! Bool, "is the current status")
            if (currentGroup!["isRequesting"] as! Bool == false) {
                self.navItem.title = "No Request"
            } else {
                self.navItem.title = "Requesting Pickup"
            }
        }
        
    }
    
    func BeginMapping() {
        
        if userLocation != nil {
            var region: MKCoordinateRegion = self.mapView.region;
            region.center = userLocation!.coordinate;
            region.span.longitudeDelta /= 8.0;
            region.span.latitudeDelta /= 8.0;
            self.mapView.setRegion(region, animated: true);
            placemark = MKPlacemark(coordinate: userLocation!.coordinate, addressDictionary: nil)
            self.mapView.addAnnotation(placemark!);
//                        self.drawRoute(placemark)
//            var altTimer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("drawRoute:"), userInfo: placemark, repeats: false)
//            var timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("drawRoute:"), userInfo: placemark, repeats: true)
            drawRoute()
            ChangeState()
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "No one is requesting pickup."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func ChangeState() {
        self.navItem.title = "En Route"
        let groupsAll = PFQuery(className: "GroupsList")
        groupsAll.getObjectInBackgroundWithId((group?.objectId)!) { (currentGroup, error) in
                currentGroup!["isRequesting"] = false
//                currentGroup!.removeObjectForKey("requestFromUser")
                currentGroup!.saveInBackground()
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        return renderer
    }
    
    func RequestingPickup() {
        let groupsList = PFQuery(className: "GroupsList")
        groupsList.getObjectInBackgroundWithId((group?.objectId)!) { (currentGroup, error) in
            print(currentGroup!["isRequesting"] as! Bool, "is the current status")
            if (currentGroup!["isRequesting"] as! Bool == false) {
                currentGroup!["isRequesting"] = true
                currentGroup!["requestFromUser"] = PFUser.currentUser()!
                self.navItem.title = "Requesting Pickup"
                currentGroup!.saveInBackground()
                self.navItem.title = "Request Made"
            } else {
                print("Someone else is currently requesting")
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Someone else is requesting pickup."
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
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
//    func drawRoute(timer: NSTimer) {
    func drawRoute() {

//        if polylines.count != 0 {
//            self.mapView.removeOverlays(self.mapView.overlays)
//        }
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: placemark!.coordinate.latitude, longitude: placemark!.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Automobile
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure your segue name in storyboard is the same as this line
        if (segue.identifier == "unwindToGroupSelectorVIewController") {
            if let destination = segue.destinationViewController as? GroupSelectorViewController {
//                let path = tableView.indexPathForSelectedRow
//                let cell = tableView.cellForRowAtIndexPath(path!)
                destination.tableView.reloadData()
//                print((destination.group?.objectId)! + "is the selected group")
//                if (requestingArray[path!.row]) {
//                    //                    print(group?.objectId)
//                    destination.userLocation = CLLocation(latitude: locationsArray[path!.row].latitude, longitude: locationsArray[path!.row].longitude)
//                } else {
//                    destination.userLocation = nil
//                }
            }
        }
    }

//    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
}

// MARK: Style
extension MapViewController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}