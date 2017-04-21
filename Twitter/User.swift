//
//  User.swift
//  Twitter
//
//  Created by victor rodriguez on 4/12/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileURL: URL?
    var profileBannerURL: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    var tweetCount: Int = 0
    var followersCount: Int = 0
    var followingCount: Int = 0
    
    init(dictionary:NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = "@" + (dictionary["screen_name"] as? String)!
        
        print(dictionary)
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString{
            profileURL = URL(string: profileURLString)
        }
        
        //"profile_banner_url" = "https://pbs.twimg.com/profile_banners/15944436/1468953558";
        let profileBannerURLString = dictionary["profile_banner_url"] as? String
        if let profileBannerURLString = profileBannerURLString{
            profileBannerURL = URL(string: profileBannerURLString)
        }
        // Example: "statuses_count" = 379579
        tweetCount = (dictionary["statuses_count"] as? Int) ?? 0
       
        // Example: "followers_count" = 806891;
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        
        // Example: "friends_count" = 46;
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
        
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    // Allow the current logged-in user to be accessed anywhere in the app.
    // If it is nil, no user is logged in.
    class var currentUser: User? {
        get {
            // When this property is accessed, this getter provides what is returned.
            // Ex. use - User.currentUser
            if _currentUser == nil{
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData{
                    // JSON object -> JSON data
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        
        // This code is executed when currentUser is assigned
        // Ex. User.currentUser = ...
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user{
                // JSON object -> JSON data
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else{
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
