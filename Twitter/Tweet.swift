//
//  Tweet.swift
//  Twitter
//
//  Created by victor rodriguez on 4/12/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timeStampString: NSString?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        //Example: "Tue Aug 28 21:08:15 +0000 2012"
        let timeStampStr = dictionary["created_at"] as? NSString
        
        if let timeStampStr = timeStampStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM d HH:mm:ss Z Y"
            timeStamp = formatter.date(from: timeStampStr as String) as NSDate?
            timeStampString = formatter.string(from: timeStamp as! Date) as NSString?
        }
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
