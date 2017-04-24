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
let twitterMentionTimelinePath = "1.1/statuses/mentions_timeline.json"
let twitterUserTimelinePath = "1.1/statuses/user_timeline.json"
let twitterVerifyCredentials = "1.1/account/verify_credentials.json"
let twitterOAuthCallback = "twitterdemo://oauth"

// Post favorite
let twitterPostFavoritePath = "1.1/favorites/create.json"

// Post retweet
let twitterPostRetweetPath = "1.1/statuses/retweet/" //:id.json

// Post tweet
let twitterPostTweetPath = "1.1/statuses/update.json"

// Show user
let twitterShowUserPath = "1.1/users/show.json"


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
                print(user)
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
    
    func postTweet(tweetMessage: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> () ){
        let param = ["status": tweetMessage]
        
        post(twitterPostTweetPath, parameters: param , progress: { (nil) in
            print("PostTweet: Progress...")
            
        }, success: { (task:URLSessionDataTask, response:Any?) in
            print("Successfully posted a new tweet: '\(tweetMessage)'")
            success(Tweet.init(dictionary: response as! NSDictionary))
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
             failure(error)
        }
    }
    
    func postFavorite(tweetID: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> () ){
        let param = ["id": tweetID]
        
        post(twitterPostFavoritePath, parameters: param, progress: { (nil) in
            print("PostFavorite: Progress...")
        }, success: { (task:URLSessionDataTask, response:Any?) in
            print("Successfully favorited a tweet: '\(tweetID)'")
            success(Tweet.init(dictionary: response as! NSDictionary))
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func postRetweet(tweetID: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> () ){
        let retweetFullUrl = twitterPostRetweetPath + tweetID + ".json"
        
        get(retweetFullUrl, parameters: nil, progress: { (nil) in
            print("PostRetweet: Progress...")
        }, success: { (task:URLSessionDataTask, response:Any?) in
            print("Successfully retweeted a tweet: '\(tweetID)'")
            success(Tweet.init(dictionary: response as! NSDictionary))
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func postReply(tweetMessage:String, tweetInResponseTo:Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> () ){
        let inReplyToID = tweetInResponseTo.tweetID
        let inReplyToScreenName = (tweetInResponseTo.user?.screenName)!
        let tweetReply = inReplyToScreenName + " " + tweetMessage
        let param = ["status": tweetReply, "in_reply_to_status_id": inReplyToID]
        
        post(twitterPostTweetPath, parameters: param , progress: { (nil) in
            print("PostTweet: Progress...")
            
        }, success: { (task:URLSessionDataTask, response:Any?) in
            print("Successfully tweeted message: '\(tweetMessage)'")
            print("As a reply for tweet id: '\(inReplyToID)'")
            success(Tweet.init(dictionary: response as! NSDictionary))
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            failure(error)
        }
        
    }
    
    func showUser(user:User ,success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        let param = ["screen_name":user.screenName!]
        get(twitterUserTimelinePath, parameters: param, progress: { (nil) in
            print("Requesting \(user.screenName)'s tweets: Progress...")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("requested \(user.screenName)'s tweets from Twitter server")
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
 
    func userTimeline(user:User ,success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        let param = ["screen_name":user.screenName!]
        print("userTimelineAPI: param: \(param)")
        // User tweets
        get(twitterUserTimelinePath, parameters: param, progress: { (nil) in
            print("Requesting \(user.screenName)'s tweets: Progress...")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("requested \(user.screenName)'s tweets from Twitter server")
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
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        // home timeline for the user that is currently logged in
        get(twitterMentionTimelinePath, parameters: nil, progress: { (nil) in
            print("Requesting mentionsTimeline: Progress...")
        }, success: { (task:URLSessionDataTask, response: Any?) in
            print("Success: Mentions timeline")
            let dictionaries = response as! [NSDictionary]
            
            // Take the array of dicts and convert it to a array of Tweet objects.
            // Because tweetsWithArray is class method, I can use the method without an istance.
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }) { (task:URLSessionDataTask?, error:Error) in
            print("Error occurred while retrieving Mentions, \(error)")
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        
        // home timeline for the user that is currently logged in
        get(twitterHomeTimelinePath, parameters: nil, progress: { (nil) in
            print("Requesting homeTimeline: Progress...")
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
        // Access the account of info for the user that is currently logged in
        get(twitterVerifyCredentials, parameters: nil, progress: { (nil) in
            print("Requesting user info from current account: Progress...")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            print("Error occured retrieving user Twitter acount information, \(error)")
            failure(error as! NSError)
        })
    }
}
