//
//  Tweet.swift
//  Twitter
//
//  Created by victor rodriguez on 4/12/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timeStamp: Date?
    var tweetID: String?
    
    var user: User?
 
    var fullName: String?
    var screenName: String?
    var profilePictureUrl: URL?

    var didUserRetweet: Bool?
    var didUserFavorite: Bool?
    
    var retweetUserName: String?
    var retweetUserScreenName: String?
    
    var retweetData: Tweet?
    
    var formattedDate: String {
        if let timeStamp = timeStamp {
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.day,.hour,.minute,.second]
            dateComponentsFormatter.maximumUnitCount = 1
            dateComponentsFormatter.unitsStyle = .abbreviated
            let formattedDateString = dateComponentsFormatter.string(from: timeStamp, to: Date()) ?? ""

            return formattedDateString
        }
        return ""
    }
    
    var detailTimeStamp: String {
        if let timeStamp = timeStamp {
            let formatter = DateFormatter()
            
            // Example: "04/17/2017, 08:13 PM"
            formatter.dateFormat = "MM/dd/yyyy, hh:mm a"
            return formatter.string(from: timeStamp)
        }
        return ""
    }
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        //print(dictionary)
        
        // Example: text = "2nd tweet";
        text = dictionary["text"] as? String
        
        // Example: "retweet_count" = 6353;
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        // Example: "favorite_count" = 278;
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        // Example: "Tue Aug 28 21:08:15 +0000 2012"
        let timeStampStr = dictionary["created_at"] as? String
        if let timeStampStr = timeStampStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampStr)
        }
        
        // Example: id_str = "853699324584247296"
        tweetID = dictionary["id_str"] as? String

        didUserRetweet = (dictionary["retweeted"] as? Bool?) ?? false
        didUserFavorite = (dictionary["favorited"] as? Bool?) ?? false
        
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            retweetData = Tweet(dictionary: retweetedStatus)
        }
        

       /* if let retweetStatusDictionary = retweetStatusDictionary{
            print("extracting retweetStatusDictionary")
            let userDictionary = retweetStatusDictionary["user"] as? NSDictionary
            fullName = userDictionary?["user"] as? String
            screenName = userDictionary?["user"] as? String
            let userImageUrlString = userDictionary?["profile_image_url_https"] as? String
            profilePictureUrl = URL(string: userImageUrlString!)
            
            let retweetUserDictionary = dictionary["user"] as! NSDictionary
            retweetUserName = retweetUserDictionary["name"] as? String
            retweetUserScreenName = retweetUserDictionary["screen_name"] as? String
        } else {
            print("retweetStatusDictionary is nil")
            let user = dictionary["user"] as? NSDictionary
            if let user = user{
                fullName = user["name"] as? String
                screenName = user["screen_name"] as? String
                let userImageUrlString = user["profile_image_url_https"] as? String
                profilePictureUrl = URL(string: userImageUrlString!)
            }
        } */
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
