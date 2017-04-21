//
//  ProfileCell.swift
//  Twitter
//
//  Created by victor rodriguez on 4/19/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

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
            //    print("coverPhotoURL = \(profileBannerURL)")
                coverPhotoImageView.setImageWith(profileBannerURL)
            }
            if let profileURL = user.profileURL{
           //     print("profilePhotoURL = \(profileURL)")
                profilePictureImageView.setImageWith(profileURL)
            }
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
