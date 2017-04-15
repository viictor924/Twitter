//
//  LoginViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/10/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func onLoginButton(_ sender: AnyObject) {
        // Initiate Oauth by providing app info
        let client = TwitterClient.sharedInstance
        print("User clicked the logIn button")
        
        client?.login( success: { () -> () in
            print("I've logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }) { (error: NSError) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
}
