//
//  TwitterClient.swift
//  Twitter
//
//  Created by victor rodriguez on 4/13/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

//App keys
let twitterBaseUrl = "https://api.twitter.com"
let twitterConsumerKey = "G9D1BUl3SZZ2eEVonCCkpcXZV"
let twitterConsumerSecret = "KpORmq0akJL6PPvSOCsSMnG6dJjiPXTWgaEz0JjVy3OOFRldZO"

//Url paths
let twitterRequestTokenPath = "oauth/request_token"
let twitterAuthUrl = "https://api.twitter.com/oauth/authorize"
let twitterAccessTokenPath = "/oauth/access_token"
let twitterHomeTimelinePath = "1.1/statuses/home_timeline.json"
let twitterVerifyCredentials = "1.1/account/verify_credentials.json"
let twitterOAuthCallback = "twitterdemo://oauth"

// Post tweet
let twitterPostTweetUrl = "1.1/statuses/update.json"


class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: twitterBaseUrl), consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        // in this method, the callback is the callback 'twitterdemo:' a type of web-like application protocol?
        fetchRequestToken(withPath: twitterRequestTokenPath, method: "GET", callbackURL: URL(string: twitterOAuthCallback), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            //      print("I got a success token")
            
            // After getting token get authorization to request user to grant access to their account
            if requestToken != nil {
                if let token = requestToken!.token {
                    let url = URL(string: twitterAuthUrl + "?oauth_token=\(token)")
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
        fetchAccessToken(withPath: twitterAccessTokenPath, method: "POST", requestToken: requestToken, success: { (credential: BDBOAuth1Credential?) in
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
    
    func postTweet(tweetMessage: String) -> Void{
        let param = ["status": tweetMessage]
        
        post(twitterPostTweetUrl, parameters: param , progress: { (nil) in
            print("PostTweet: Progress...")
        }, success: { (task:URLSessionDataTask, response:Any?) in
            print("Successfully posted a new tweet: '\(tweetMessage)'")
           
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        
        // User tweets
        get(twitterHomeTimelinePath, parameters: nil, progress: { (nil) in
            print("Requesting tweets: Progress...")
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
        get(twitterVerifyCredentials, parameters: nil, progress: { (nil) in
            print("Requesting user info: Progress...")
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
