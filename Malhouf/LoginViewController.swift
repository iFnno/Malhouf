//
//  LoginViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TTGSnackbar

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: TicketTextField2!
    
    @IBOutlet weak var passwordField: TicketTextField2!
    
    
    @IBAction func loginButton(_ sender: Any) {
        login()
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "timer") as UIViewController
        //        self.present(controller, animated: true, completion: nil)
        //
        
        
    }
    
   
    func login() {
        if(!((emailField.text?.isEmpty)!) && !((passwordField.text?.isEmpty)!)) {
            let parameters: Parameters=[
                "email": "user@email.com",
                "password": "hellowdfgdfgd word"
            ]
            let requestURL = "http://malahuf-212116.appspot.com/api/user"
            
            
            Alamofire.request(requestURL, method: .post, parameters: parameters).responseData { (response) -> Void in
                print("Data: \(response)")
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    if let resData = swiftyJsonVar["name"].arrayObject {
                        print("Name: \(resData)")
                    }
                    if let userId = swiftyJsonVar["id"].arrayObject {
                        print("Name: \(userId)")
                    }
                    
                    
                    
                }
                
                
            }
            self.performSegue(withIdentifier: "rescue", sender: nil)
        }
        else {
            let snackbar = TTGSnackbar(message: "Email or Password are not correct", duration: .short)
            snackbar.show()
        }
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   self.hideKeyboardWhenTappedAround() 
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    
}
// Put this piece of code anywhere you like
extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
