//
//  HomeViewController.swift
//  Malhouf
//
//  Created by Afnan S on 8/2/18.
//  Copyright © 2018 hajjhackthon. All rights reserved.
//

import UIKit
var role : String! = ""
class HomeViewController: UIViewController {

    @IBAction func ambluanceButton(_ sender: Any) {
        let alertController = UIAlertController(title: "                                     ", message: "                                       " , preferredStyle: UIAlertControllerStyle.alert)
        var imageView = UIImageView(frame: CGRect(x: 90, y: 0, width: 90, height: 90))
        imageView.image = #imageLiteral(resourceName: "amblunce confirm")
        alertController.view.addSubview(imageView)
        let OKAction = UIAlertAction(title: "نعم", style: .default) { (action:UIAlertAction!) in
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
         imageView.image = #imageLiteral(resourceName: "raising-hand-confirm")
         alertController.view.addSubview(imageView)
        let OKAction = UIAlertAction(title: "نعم", style: .default) { (action:UIAlertAction!) in
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
    
    
    @IBOutlet weak var ambluanceText: UILabel!
    
    @IBOutlet weak var helpText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
