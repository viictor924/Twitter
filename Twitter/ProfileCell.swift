//
//  ProfileCell.swift
//  Twitter
//
//  Created by victor rodriguez on 4/19/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileCell: UITableViewCell {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var user: User!{
        didSet{
            if let profileBannerURL = user.profileBannerURL{
                
                coverPhotoImageView.setImageWith(profileBannerURL)
                /*
                let imageRequest = URLRequest(url: profileBannerURL)
                
                coverPhotoImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                    
                    print("Successfully downloaded banner picture")
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                      print("fading in image")
                        self.coverPhotoImageView.alpha = 0.0
                        self.coverPhotoImageView.image = image
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.coverPhotoImageView.alpha = 1.0
                        })
                    }
                    
                }, failure: { (imageRequest, imageResponse, error) in
                    print("error downloading profile banner image")
                })
                */
            } else { print("bannerURL is nil") }
            
            if let profileURL = user.profileURL{
                
                profilePictureImageView.setImageWith(profileURL)
            /*    let imageRequest = URLRequest(url: profileURL)
                
                profilePictureImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                    print("Successfully downloaded banner picture")
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("fading in image")
                        self.profilePictureImageView.alpha = 0.0
                        self.profilePictureImageView.image = image
                        
                        UIView.animate(withDuration: 0.6, animations: {
                            self.profilePictureImageView.alpha = 1.0
                        })
                    }
                    
                }, failure: { (imageRequest, imageResponse, error) in
                    print("error downloading profile banner image")
                }) */
                
            } else { print("profileURL is nil") }
            fullNameLabel.text = user.name
            screenNameLabel.text = user.screenName
            tweetCountLabel.text = "\(user.tweetCount)"
            followerCountLabel.text = "\(user.followersCount)"
            followingCountLabel.text = "\(user.followingCount)"
            
           // print("Full name = \(user.name)")
           // print("Screen name = \(user.screenName)")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
