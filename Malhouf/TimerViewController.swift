//
//  TimerViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


var startedAlready = false
var globalMin = 0
var globalSec = 0
var globalhour = 0
var startTime : String! = "2017/12/12 00:00:00"

class TimerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var requestsArray = ["لديك طلب على بعد 40 متر"]
    
    var timer = Timer()
    var isRunnnig = false
    var min = 0
    var hour = 0
    var secon = 0
    var date : String! = ""
    var fromTab = false
    var totalTime : String! = ""
    
    
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var minutes: UILabel!
    
    @IBOutlet weak var seconds: UILabel!
    
    
    @IBOutlet weak var todayDate: UILabel!
    
    @IBOutlet weak var switchDemo: UISwitch!
    
    
    
    func run() -> Void {
        if !self.isRunnnig {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.action), userInfo: nil, repeats: true)
            self.isRunnnig = true
            
        }
    }
    @objc func action()
    {
        secon = secon + 1
        seconds.text = String(secon)
        
        if secon == 60 {
            secon = 0
            min = min + 1
            seconds.text = String(secon)
            minutes.text = String(min)
        }
        if min == 60 {
            min = 0
            hour = hour + 1
            minutes.text = String(min)
            hours.text = String(hour)
        }
        
        
    }
    override func viewDidLoad() {
        
        getRequests()
        
        
        switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if startedAlready == false {
            startedAlready = true
            run()
        } else {
            startedAlready = false
            self.totalTime = String(self.hour) + ":" + String(self.min) + ":" + String(self.secon)
            self.secon = 0
            self.min = 0
            self.hour = 0
            self.seconds.text = "00"
            self.minutes.text = "00"
            self.hours.text = "00"
            self.timer.invalidate()
            self.isRunnnig = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hour = 0
        self.min = 0
        self.secon = 0
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = String(formatter.string(from: date))
        //    self.todayDate.text = self.date
        if startedAlready == true {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let startTime1 = formatter.date(from: startTime)!
            let units: Set<Calendar.Component> = [.hour, .minute, .second]
            let difference = Calendar.current.dateComponents(units, from: startTime1, to: date)
            self.hour = difference.hour!
            self.min = difference.minute!
            self.secon = difference.second!
            seconds.text = String(self.secon)
            minutes.text = String(self.min)
            hours.text = String(self.hour)
            self.run()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "track" {
            let destVC = segue.destination as! RescuerMapVC
            destVC.index = sender as? String
        }
    }
    
    func getRequests() {
        
        let parameters: Parameters=[
            "id": "2"
        ]
        
        let requestURL = "http://malahuf-212116.appspot.com/api/request/all"
        
        
        Alamofire.request(requestURL, method: .post, parameters: parameters).responseData { (response) -> Void in
            print("Data: \(response)")
            if((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print("All: ",swiftyJsonVar)
                //                if let resData = swiftyJsonVar["message"].arrayObject {
                //                    print("Array: \(resData)")
                //                }
                
                
                
            }
            
            
        }
        
    }
    
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = requestsArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "                                     ", message: "                                       " , preferredStyle: UIAlertControllerStyle.alert)
        var imageView = UIImageView(frame: CGRect(x: 90, y: 0, width: 90, height: 90))
        imageView.image = #imageLiteral(resourceName: "raising-hand-confirm")
        alertController.view.addSubview(imageView)
        let OKAction = UIAlertAction(title: "نعم", style: .default) { (action:UIAlertAction!) in
            
            let index = self.requestsArray[indexPath.row]
            self.performSegue(withIdentifier: "track", sender: index)
            
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "تراجع", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }
}
