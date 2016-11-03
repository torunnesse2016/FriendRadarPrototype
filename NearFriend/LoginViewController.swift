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
import KRProgressHUD


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
            
            // call web service for Login
            KRProgressHUD.show(message:"Logging in...")
            //http://127.0.0.1:81/login?email=email@test.ru&password=test4
            let url_temp = AppConstants.BASE_URL+"/login?email="+txtEmail.text!+"&password="+txtPassword.text!
            let url = url_temp.addingPercentEscapes(using: String.Encoding.utf8)
            
            Alamofire.request(url!).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    KRProgressHUD.dismiss()
                    let responseDictionary = JSON as! NSDictionary
                    let success = responseDictionary.object(forKey: "sucess")! as! Bool
                    if (success){
                        let userID:NSNumber = (responseDictionary["user_id"]) as! NSNumber
                        //save email, user name, password = id
                        UserDefaults.standard.set(self.txtEmail.text!, forKey: "UserEmail")
                        UserDefaults.standard.set(self.txtPassword.text!, forKey: "password")
                        UserDefaults.standard.set("user name", forKey: "UserName")
                        UserDefaults.standard.set(String(describing: userID), forKey: "UserID")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "LoginToChooseLocation", sender: self)
                    }else{
                        let alert = AlertController(title: "Information!", message: "Sign up Failed", style: .alert)
                        alert.addAction(AlertAction(title: "OK", style: .cancel))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
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
