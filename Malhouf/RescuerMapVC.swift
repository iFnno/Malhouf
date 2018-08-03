//
//  RescuerMapVC.swift
//  Malhouf
//
//  Created by Noura Aziz on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON


class RescuerMapVC: UIViewController {
    
    @IBOutlet weak var subView: UIView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    //    var camera: GMSCameraPosition!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var index: String?
    
    var originPoint: String?
    var desctination: String?
    
    struct State {
        let name: String
        let long: CLLocationDegrees
        let lat: CLLocationDegrees
    }
    
    let states = [
        State(name: "Hyde park", long: 39.162773, lat: 21.557512),
        State(name: "Alabama", long: 39.128441, lat: 21.626466),
        // the other 51 states here...
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        print("Index: \(index ?? "")")
    }
    
    func initMap() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func drawMarker() {
        var markerDict: [String: GMSMarker] = [:]
        
        for state in states {
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.long)
            state_marker.title = state.name
            state_marker.snippet = "Hey, this is \(state.name)"
            state_marker.map = mapView
            markerDict[state.name] = state_marker
        }
    }
    func drawDirection() {
        
        let origin = originPoint
        let destination = desctination
        print("Orig: \(origin ?? "")")
        print("Dest: \(destination ?? "")")
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin ?? "")&destination=\(destination ?? "")&key=AIzaSyAv9wneUyb_z-OxIHQTy8Di0CFBt_ydUG0"
        
        
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
    
    func getRequests() {
        
        let parameters: Parameters=[
            "id": "2"
        ]
        
        let requestURL = "http://malahuf-212116.appspot.com/api/request/all"
        
        
        Alamofire.request(requestURL, method: .post, parameters: parameters).responseData { (response) -> Void in
            //            print("Data: \(response)")
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                let index1 = swiftyJsonVar[0]
                
                print("index: \(index1)")
                let loc = index1["location"]
                let coord1 = loc["coordinates"]
                print("Loc: \(loc)")
                
                let coord10 = coord1[0].doubleValue
                let coord11 = coord1[1].doubleValue
                
                self.desctination = "\(coord10),\(coord11)"
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(coord10), longitude: coord11)
                state_marker.title = "1"
                state_marker.icon = GMSMarker.markerImage(with: .blue)
                
                //            state_marker.icon = UIImage(named: "marker-blue")
                state_marker.snippet = "Hey, this is 1"
                state_marker.map = self.mapView
            }
            self.drawDirection()
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
       
        role = "help"
        _ = navigationController?.popViewController(animated: true)
        
        //         self.performSegue(withIdentifier: "rescue", sender: nil)
    }
    
    
}
extension RescuerMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        self.originPoint = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        self.subView.addSubview(mapView)
        
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        getRequests()
    }
    
}
