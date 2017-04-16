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
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    
    var timeStampString: String?
    var screenName: String?
    var profilePictureUrl: URL?
    var fullName: String?
    
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
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        // Example: text = "2nd tweet";
        text = dictionary["text"] as? String
        
        // Example: "Tue Aug 28 21:08:15 +0000 2012"
        let timeStampStr = dictionary["created_at"] as? String
        if let timeStampStr = timeStampStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampStr)
        }
        
        // Example: "retweet_count" = 0;
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        // Example: "favourites_count" = 0;
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
       
        
        
        /*
        let userDictionary = dictionary["user"] as? NSDictionary
        
        if let userDictionary = userDictionary{
            //name = "Victor Rodriguez";
            fullName = userDictionary["name"] as? String
            
            //"screen_name" = viictor924;
            screenName = userDictionary["screen_name"] as? String
            
            //"profile_image_url_https" = "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png";
            let imageUrlString = userDictionary["profile_image_url_https"] as? String
            if let imageUrlString = imageUrlString {
                profilePictureUrl = URL(string: imageUrlString)
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
