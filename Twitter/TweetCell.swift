//
//  TweetCell.swift
//  Twitter
//
//  Created by victor rodriguez on 4/14/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var tweetStatusLabel: UILabel!
    
    @IBOutlet weak var retweetStatusImageView: UIButton!
    
    
    var tweet: Tweet!{
        didSet{
            // Retweet flow
            if let retweetData = tweet.retweetData {
                tweetStatusLabel.isHidden = false
                retweetStatusImageView.isHidden = false
                retweetButton.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
                
                if let user = tweet.user {
                    tweetStatusLabel.text = "\(user.name!) retweeted"
                } else {
                    tweetStatusLabel.text = "retweeted"
                }
                
                if let originalUser = retweetData.user {
                    fullNameLabel.text = originalUser.name
                    screenNameLabel.text = "\(originalUser.screenName!)"
                    tweetTextLabel.text = retweetData.text
                    
                    if let profileImageURL = originalUser.profileURL {
                        profilePictureImageView.setImageWith(profileImageURL)
                    }
                }
                
                retweetCountLabel.text = retweetData.retweetCount == 0 ? "" : "\(retweetData.retweetCount)"
                favoriteCountLabel.text = retweetData.favoritesCount == 0 ? "" : "\(retweetData.favoritesCount)"
                timestampLabel.text = retweetData.formattedDate
                
                if retweetData.didUserFavorite!{
                    favButton.setImage(#imageLiteral(resourceName: "likeActive"), for: .normal)
                } else {
                    favButton.setImage(#imageLiteral(resourceName: "likeInactive"), for: .normal)
                }
                
                if retweetData.didUserRetweet! {
                    retweetButton.setImage(#imageLiteral(resourceName: "retweetGreenActive"), for: .normal)
                } else {
                    retweetButton.setImage(#imageLiteral(resourceName: "retweet-1"), for: .normal)
                }
            } else {
                // Original tweet Flow
                tweetStatusLabel.isHidden = true
                retweetStatusImageView.isHidden = true
                if let user = tweet.user{
                    //data from tweet model
                    tweetTextLabel.text = tweet.text as String?
                    timestampLabel.text = tweet.formattedDate
                    retweetCountLabel.text = "\(tweet.retweetCount)"
                    favoriteCountLabel.text = "\(tweet.favoritesCount)"
                    
                    //data from user model
                    screenNameLabel.text = user.screenName
                    fullNameLabel.text = user.name
                    profilePictureImageView.setImageWith(user.profileURL!)
                }
            }
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
