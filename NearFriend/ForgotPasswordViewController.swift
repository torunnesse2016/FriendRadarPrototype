//
//  ForgotPasswordViewController.swift
//  NearFriend
//
//  Created by MobileDev on 11/1/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import SimpleAlert

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func checkValidate() -> Bool {
        
        var message:String!
        var isDiplayAlert:Bool = false

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
    @IBAction func onClickSend(_ sender: AnyObject) {
            if (self.checkValidate()){
                let alert = AlertController(title: "Information!", message: "Sent your password to your Email.", style: .alert)
                alert.addAction(AlertAction(title: "OK", style: .cancel))
                present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
