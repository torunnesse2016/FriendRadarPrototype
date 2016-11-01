//
//  LoginViewController.swift
//  NearFriend
//
//  Created by MobileDev on 10/31/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookCore
import FacebookLogin
import SimpleAlert
import Alamofire


class LoginViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignupFacebook: UIButton!

    var fbaccessToken:AccessToken!
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.title = "Log In"
        
        currentLocation = locationManager.location
        
        print("Current Locations = \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
       
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func onClickedLogin(_ sender: AnyObject) {
        if (self.checkValidate()){
            
//            let baseURL:String!
//            baseURL = "baseurl"
//            let url:String = baseURL+"/login?useremail="+txtEmail.text!+"&password="+txtPassword.text!
//            Alamofire.request(url).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//            }
            
            UserDefaults.standard.set(txtEmail.text, forKey: "UserEmail")
            UserDefaults.standard.set(txtPassword.text, forKey: "password")
            UserDefaults.standard.set("test user", forKey: "UserName")
            UserDefaults.standard.set("temp id", forKey: "UserID")
            UserDefaults.standard.synchronize()
            
             self.performSegue(withIdentifier: "LoginToChooseLocation", sender: self)
        }
    }
    @IBAction func onClickedForgotPassword(_ sender: AnyObject) {
    }

//    @IBAction func onClickedLogin(_ sender: AnyObject) {
//        //check user name and password
//        self.performSegue(withIdentifier: "LoginToChooseLocation", sender: self)
//    }

    @IBAction func onClickedSignup(_ sender: AnyObject) {
        
           self.performSegue(withIdentifier: "loginToSignup", sender: self)
    }
    
    func checkValidate() -> Bool {
        
        var message:String!
        var isDiplayAlert:Bool = false
        if (txtPassword.text?.isEmpty)! {
            message = "Please input Password."
            isDiplayAlert = true
        }

        if (txtEmail.text?.isEmpty)! {
            message = "Please input Email."
            isDiplayAlert = true
        }
        
        
        
        if isDiplayAlert {
            let alert = AlertController(title: "Information!", message: message, style: .alert)
            alert.addAction(AlertAction(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
            return false
        }else{
            return true
        }

    }

   
    //Getting Current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation = manager.location
        print("Updated locations = \(locValue.latitude) \(locValue.longitude)")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "LoginToChooseLocation") {
            let viewController:ChooseLocationViewController = segue.destination as! ChooseLocationViewController
            viewController.currentLocation = self.currentLocation
        }else if(segue.identifier == "loginToSignup"){
            let viewController:SignupViewController = segue.destination as! SignupViewController
            viewController.currentLocation = self.currentLocation
        }
    }
    

}
