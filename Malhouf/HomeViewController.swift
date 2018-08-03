//
//  HomeViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation


var role : String! = ""
class HomeViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var userLang: String?
    var userLat: String?
    var rescuerID: String?
    
    @IBAction func ambluanceButton(_ sender: Any) {
        let alertController = UIAlertController(title: "                                     ", message: "                                       " , preferredStyle: UIAlertControllerStyle.alert)
        var imageView = UIImageView(frame: CGRect(x: 90, y: 0, width: 90, height: 90))
        imageView.image = UIImage(named: "ambu-confirm")
        alertController.view.addSubview(imageView)
        let OKAction = UIAlertAction(title: "نعم", style: .default) { (action:UIAlertAction!) in
            self.createRequest(type: "medic")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "hajj") as UIViewController
            role = "ambluance"
            self.present(controller, animated: true, completion: nil)
            
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "تراجع", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        
        
        
        self.present(alertController, animated: true, completion:nil)
        
        
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let alertController = UIAlertController(title: "                                     ", message: "                                       " , preferredStyle: UIAlertControllerStyle.alert)
        var imageView = UIImageView(frame: CGRect(x: 90, y: 0, width: 90, height: 90))
        imageView.image = UIImage(named: "help-confirm")
        alertController.view.addSubview(imageView)
        let OKAction = UIAlertAction(title: "نعم", style: .default) { (action:UIAlertAction!) in
            self.createRequest(type: "volunteer")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "hajj") as UIViewController
            role = "help"
            self.present(controller, animated: true, completion: nil)
            
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "تراجع", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        navigationController?.pushViewController(LoginViewController, animated: true)
        
    }
    func initMap() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    @IBOutlet weak var ambluanceText: UILabel!
    
    @IBOutlet weak var helpText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRequest(type: String) {
        
        let parameters: Parameters = [
            "status": "on",
            "type": type,
            "longitude": userLang ?? "",
            "latitude": userLat ?? "",
            "rescuers": rescuerID ?? ""
        ]
        
        let requestURL = "http://malahuf-212116.appspot.com/api/request/new"
        
        
        Alamofire.request(requestURL, method: .post, parameters: parameters).responseData { (response) -> Void in
            print("Data: \(response)")
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print("Req: ",swiftyJsonVar)
                //                if let resData = swiftyJsonVar["message"].arrayObject {
                //                    print("Array: \(resData)")
                //                }
                
                
                
            }
            
            
        }
        
    }
    
    func getData() {
        print("userLang: \(userLang ?? "")")
        print("userLat: \(userLat ?? "")")
        
        let parameters: Parameters=[
            "longitude": userLat ?? "",
            "latitude": userLang ?? ""
        ]
        
        let requestURL = "http://malahuf-212116.appspot.com/api/rescuer"
        
        
        Alamofire.request(requestURL, method: .post, parameters: parameters).responseData { (response) -> Void in
            //            print("Data: \(response)")
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                //                print("First: ",swiftyJsonVar[0])
                let first = swiftyJsonVar[0]
                print(first["id"].stringValue)
                self.rescuerID = "\(first["id"])"
                //                if let userID = swiftyJsonVar[0]["id"].stringValue {
                //                    print("userID: \(userID)")
                //                }
                //
                
                
            }
            
            
        }
        
    }
    
    
}
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        self.userLat = "\(location.coordinate.latitude)"
        self.userLang = "\(location.coordinate.longitude)"
        
        getData()
        
    }
}
