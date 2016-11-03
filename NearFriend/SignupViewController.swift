//
//  SignupViewController.swift
//  NearFriend
//
//  Created by MobileDev on 10/31/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookCore
import FacebookLogin
import KRProgressHUD
import SimpleAlert
import Alamofire
import SwiftyJSON

class SignupViewController: UIViewController {

    var fbaccessToken:AccessToken!
    var currentLocation:CLLocation!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickedSignup(_ sender: AnyObject) {
        
        if (self.checkValidate()){
            KRProgressHUD.show(message:"Sign up...")
            // http://127.0.0.1:81/signup?email=email@test.ru&password=test&username=test
            let url_temp = AppConstants.BASE_URL+"/signup?email="+txtEmail.text!+"&password="+txtPassword.text!+"&username="+txtUsername.text!
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
                        UserDefaults.standard.set(self.txtEmail.text, forKey: "UserEmail")
                        UserDefaults.standard.set(self.txtPassword.text, forKey: "password")
                        UserDefaults.standard.set(self.txtUsername.text, forKey: "UserName")
                        UserDefaults.standard.set(String(describing: userID), forKey: "UserID")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "signupToChooseLocation", sender: self)
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
    func checkValidate() -> Bool {
        
        var message:String!
        var isDiplayAlert:Bool = false
        
        
        if (txtPassword.text != txtConfirmPassword.text) {
            message = "Password don't match."
            isDiplayAlert = true
        }
        if (txtConfirmPassword.text?.isEmpty)! {
            message = "Please input Confirm Password."
            isDiplayAlert = true
        }
        if (txtPassword.text?.isEmpty)! {
            message = "Please input Password."
            isDiplayAlert = true
        }
        if (txtEmail.text?.isEmpty)! {
            message = "Please input Email."
            isDiplayAlert = true
        }
        
        if (txtUsername.text?.isEmpty)! {
            message = "Please input User Name."
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
    @IBAction func onClickedFBSignup(_ sender: AnyObject) {
        
//        KRProgressHUD.show(message:"Authenticating...")
        
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile,.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
//                KRProgressHUD.dismiss()
            case .cancelled:
                print("User cancelled login.")
//                KRProgressHUD.dismiss()
            case .success(let grantedPermissions, let declinedPermissions, let AccessToken):
                print("Logged in!")
//                KRProgressHUD.dismiss()
//                KRProgressHUD.show(message:"Authenticating...")

                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,id,name"], tokenString: AccessToken.authenticationToken, version: nil, httpMethod: "GET")
                
                req?.start(completionHandler: { (connection, result, error) in
                    if(error == nil)
                    {
                        print("result \(result)")
                        
                        
                        let user:NSDictionary  = result as! NSDictionary
                        let email:String = user.object(forKey: "email") as! String
                        let name:String = user.object(forKey: "name") as! String
                        let id:String = user.object(forKey: "id") as! String

                        // call web service for sign up
                        KRProgressHUD.show(message:"Sign up...")
                        // http://127.0.0.1:81/signup_fb?email=email_fb3@test.ru&facebookid=102030405&username=test
                        let url_temp = AppConstants.BASE_URL+"/signup_fb?email="+email+"&facebookid="+id+"&username="+name
                        
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
                                    UserDefaults.standard.set(email, forKey: "UserEmail")
                                    UserDefaults.standard.set("facebook_signup", forKey: "password")
                                    UserDefaults.standard.set(name, forKey: "UserName")
                                    UserDefaults.standard.set(String(describing: userID), forKey: "UserID")
                                    UserDefaults.standard.synchronize()
                                    self.performSegue(withIdentifier: "signupToChooseLocation", sender: self)
                                }else{
                                    let alert = AlertController(title: "Information!", message: "Sign up Failed", style: .alert)
                                    alert.addAction(AlertAction(title: "OK", style: .cancel))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            case .failure(let error):
                               KRProgressHUD.dismiss()
                                print("Request failed with error: \(error)")
                            }
                            
                        }
                    }
                    else
                    {
                        KRProgressHUD.dismiss()
                        print("error \(error)")
                    }
                })
                
            }}

        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "signupToChooseLocation") {
            let viewController:ChooseLocationViewController = segue.destination as! ChooseLocationViewController
            viewController.currentLocation = self.currentLocation
        }
    }

}
