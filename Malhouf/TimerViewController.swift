//
//  TimerViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
var startedAlready = false
var globalMin = 0
var globalSec = 0
var globalhour = 0
var startTime : String! = "2017/12/12 00:00:00"

class TimerViewController: UIViewController {

    
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
        switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
   
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
    self.todayDate.text = self.date
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

}
