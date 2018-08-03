//
//  ViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON


class MapViewController: UIViewController {
    
    
    @IBOutlet weak var subView: UIView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var lonReq: String?
    var latReq: String?
    
    struct State {
        let name: String
        let long: CLLocationDegrees
        let lat: CLLocationDegrees
    }
    
    var states = [
        
        State(name: "Alabama", long: 39.128441, lat: 21.626466),
        // the other 51 states here...
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initMap() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }

    var arrRes = [[String:AnyObject]]() //Array of dictionary
    func getData() {

        let parameters: Parameters = [
            "longitude": "39.162773",
            "latitude": "21.557512"
        ]
        
        let requestURL = "http://malahuf-212116.appspot.com/api/rescuer"
        

        Alamofire.request(requestURL, method: .post, parameters: parameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let index1 = swiftyJsonVar[0]
                let index2 = swiftyJsonVar[1]
                let index3 = swiftyJsonVar[2]
                print("index: \(index1)")
                let loc = index1["location"]
                let coord1 = loc["coordinates"]
                print("Loc: \(loc)")
                
                let coord10 = coord1[0].doubleValue
                let coord11 = coord1[1].doubleValue
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(coord10), longitude: coord11)
                state_marker.title = "1"
                state_marker.icon = GMSMarker.markerImage(with: .blue)
                
                
                state_marker.snippet = "Hey, this is 1"
                state_marker.map = self.mapView
                
                // 1
                let loc1 = index2["location"]
                let coord12 = loc1["coordinates"]
                print("Loc: \(loc)")
                
                let coord20 = coord12[0].doubleValue
                let coord21 = coord12[1].doubleValue
                let state_marker1 = GMSMarker()
                state_marker1.position = CLLocationCoordinate2D(latitude: coord20, longitude: coord21)
                state_marker1.title = "1"
                state_marker1.icon = GMSMarker.markerImage(with: .blue)
                state_marker1.snippet = "Hey, this is 1"
                state_marker1.map = self.mapView
                
                //2
                let loc2 = index3["location"]
                let coord13 = loc2["coordinates"]
                print("Loc: \(loc)")
                
                let coord30 = coord13[0].doubleValue
                let coord31 = coord13[1].doubleValue
                let state_marker2 = GMSMarker()
                state_marker2.position = CLLocationCoordinate2D(latitude: coord30, longitude: coord31)
                state_marker2.title = "1"
                state_marker2.icon = GMSMarker.markerImage(with: .blue)
                state_marker2.snippet = "Hey, this is 1"
                state_marker2.map = self.mapView
            }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
//       _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    func drawMarker() {
        var markerDict: [String: GMSMarker] = [:]
        
        for state in states {
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.long)
            state_marker.title = state.name
            state_marker.icon = GMSMarker.markerImage(with: .blue)
            
            //            state_marker.icon = UIImage(named: "marker-blue")
            state_marker.snippet = "Hey, this is \(state.name)"
            state_marker.map = mapView
            markerDict[state.name] = state_marker
        }
    }
    func drawDirection() {
        
        let origin = "\(21.557512),\(39.162773)"
        let destination = "\(21.626466),\(39.128441)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyAv9wneUyb_z-OxIHQTy8Di0CFBt_ydUG0"
        
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let routes = swiftyJsonVar["routes"].arrayValue
                print(routes)
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .green
                    polyline.strokeWidth = 3.0
                    polyline.map = self.mapView
                    
                }
                
            }
        }
        
        
    }
    
    
    
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        self.lonReq = "\(location.coordinate.longitude)"
        self.latReq = "\(location.coordinate.latitude)"
        
        camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 20.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        self.subView.addSubview(mapView)
        
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        getData()
        drawDirection()
    }
    
}

