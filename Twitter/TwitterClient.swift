//
//  TwitterClient.swift
//  Twitter
//
//  Created by victor rodriguez on 4/13/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "G9D1BUl3SZZ2eEVonCCkpcXZV", consumerSecret: "KpORmq0akJL6PPvSOCsSMnG6dJjiPXTWgaEz0JjVy3OOFRldZO")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        // in this method, the callback is the callback 'twitterdemo:' a type of web-like application protocol?
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            //      print("I got a success token")
            
            // After getting token get authorization to request user to grant access to their account
            if requestToken != nil {
                if let token = requestToken!.token {
                    let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
                    print("I got a  request token: \(token)")
                    
                    // Go to Twitter authorization url
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (success: Bool) in
                        if success {
                            print("Successfully redirected to Twitter authorization url.")
                        } else {
                            //              print("Could not access Twitter authorization url")
                        }
                    })
                }
            }
        }, failure: { (error: Error?) in
            self.loginFailure?(error as! NSError)
            print("Error getting request token, \(error)")
        })
        
    }
    
    func logOut(){
        deauthorize()
        User.currentUser = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query!)
        fetchAccessToken(withPath: "/oauth/access_token", method: "POST", requestToken: requestToken, success: { (credential: BDBOAuth1Credential?) in
            print("I got an access token!")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error:NSError) in
                self.loginFailure?(error )
            })
            
        
        }, failure: { (error: Error?) in
           // self.loginFailure
            print("error: \(error)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        
        // User tweets
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: { (nil) in
            print("Progress...")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("requested tweets from Twitter server")
            let dictionaries = response as! [NSDictionary]
            
            // Take the array of dicts and convert it to a array of Tweet objects.
            // Because tweetsWithArray is class method, I can use the method without an istance.
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)

        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            print("Error occurred while retrieving tweets, \(error)")
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) ->()){
        // Access users account info
        get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: { (nil) in
            print("Progress...")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            
            // print("account: \(response)")
            print("Name: \(user.name!)")
            print("Screenname: \(user.screenName!)")
            print("profile url: \(user.profileURL!)")
            print("description: \(user.tagline!)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            print("Error occured retrieving user Twitter acount information, \(error)")
            failure(error as! NSError)
        })
    }
}
