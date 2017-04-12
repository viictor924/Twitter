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
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "G9D1BUl3SZZ2eEVonCCkpcXZV", consumerSecret: "KpORmq0akJL6PPvSOCsSMnG6dJjiPXTWgaEz0JjVy3OOFRldZO")
        

        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) -> Void in
            
            if let token = requestToken?.token{
            print("I got a token!")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            UIApplication.shared.open(url, options: [:], completionHandler: { (success: Bool) in
                if success {
                    print("I was able to access Twitter's authorization URL")
                    
                    twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                      //  print("account: \(response)")
                        
                        let user = response as? NSDictionary
                      //  print("User = \(user?["name"])")
                        
                    }, failure: { (task:URLSessionDataTask?, error:Error) in
                       print("error: \(error.localizedDescription)")
                    })
                    
                    twitterClient?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                        let tweets = response as! [NSDictionary]
                        
                        for tweet in tweets{
                            print("I'm iterating through my tweets")
                            print("tweet: \(tweet["text"])")
                        }
                        
                      let user = response as? NSDictionary
                        print("User = \(user)")
                        print("Screen Name = \(user?["screen_name"])")
                        print("profile_image_URL = \(user?["profile_image_url_https"])")
                        print("Description = \(user?["description"])")
                    }, failure: { (task:URLSessionDataTask?, error:Error) in
                        print("error: \(error.localizedDescription)")
                    })
                    
                    
                }
                else {
                    print("I was not able to access Twitter's authorization URL")
                }
                
            })
            }
        }){ (error: Error?) in
            print("error: \(error!.localizedDescription)")
        }
        
        
    }
    
    
    /*
     @IBAction func onLoginButton(_ sender: AnyObject) {
     let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "G9D1BUl3SZZ2eEVonCCkpcXZV", consumerSecret: "KpORmq0akJL6PPvSOCsSMnG6dJjiPXTWgaEz0JjVy3OOFRldZO")
     
     
     twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: { (requestToken:BDBOAuth1Credential?)  in
     print("I got a token!")
     }, failure: { (error: Error?) in
     // print("error: \(error!.localizedDescription)")
     })
     
     }
     */

}
