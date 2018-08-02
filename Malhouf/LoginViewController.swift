//
//  LoginViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailField: TicketTextField2!
    
    @IBOutlet weak var passwordField: TicketTextField2!
    
    
    @IBAction func loginButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "timer") as UIViewController
        self.present(controller, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func forgetPassword(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
