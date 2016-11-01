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
            
            
//            let baseURL:String!
//            baseURL = "baseurl"
//            let url:String = baseURL+"/signup?useremail="+txtEmail.text+"&username="+txtUsername.text+"&password="+txtPassword.text
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

            
            //save email, user name, password = id
            UserDefaults.standard.set(txtEmail.text, forKey: "UserEmail")
            UserDefaults.standard.set(txtPassword.text, forKey: "password")
            UserDefaults.standard.set(txtUsername.text, forKey: "UserName")
            UserDefaults.standard.set("temp id", forKey: "UserID")
            UserDefaults.standard.synchronize()
            
            self.performSegue(withIdentifier: "signupToChooseLocation", sender: self)
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

                        
//                        let baseURL:String!
//                        baseURL = "baseurl"
//                        let url:String = baseURL+"/fbsignup?useremail="+email+"&username="+name+"&userid="+id
//                        Alamofire.request(url).responseJSON { response in
//                            print(response.request)  // original URL request
//                            print(response.response) // HTTP URL response
//                            print(response.data)     // server data
//                            print(response.result)   // result of response serialization
//                            
//                            if let JSON = response.result.value {
//                                print("JSON: \(JSON)")
//                            }
//                        }
                        
                        
                        //save email, user name, password = id
                        UserDefaults.standard.set(email, forKey: "UserEmail")
                        UserDefaults.standard.set("temppassword", forKey: "password")
                        UserDefaults.standard.set(name, forKey: "UserName")
                        UserDefaults.standard.set(id, forKey: "UserID")
                        UserDefaults.standard.synchronize()

                        
                        
                        
                        self.performSegue(withIdentifier: "signupToChooseLocation", sender: self)
                    }
                    else
                    {
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
