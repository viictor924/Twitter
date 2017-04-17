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

    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            if let user = tweet.user{
                //data from tweet model
                tweetTextLabel.text = tweet.text as String?
                timestampLabel.text = tweet.formattedDate
                replyCountLabel.text = "\(tweet.replyCount)"
                retweetCountLabel.text = "\(tweet.retweetCount)"
                favoriteCountLabel.text = "\(tweet.favoritesCount)"
                
                //data from user model
                screenNameLabel.text = user.screenName
                fullNameLabel.text = user.name
                profilePictureImageView.setImageWith(user.profileURL!)
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
