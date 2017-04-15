//
//  User.swift
//  Twitter
//
//  Created by victor rodriguez on 4/12/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    
    init(dictionary:NSDictionary){
        
        name = dictionary["name"] as? NSString
        screenName = dictionary["screen_name"] as? NSString
        let profileURLString = dictionary["profile_image_url_https"] as? NSString
        if let profileURLString = profileURLString{
            profileURL = NSURL(string: profileURLString as String)
        }
        tagline = dictionary["description"] as? NSString
        
        }

}
