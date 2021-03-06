//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/16/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    var tweetID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserDetails()
        customizeNavigationBar()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =============== IB Action Methods ===========================
    @IBAction func onTimelineButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if let tweetID = tweet.tweetID {
            print("User clicked the favorite button on tweet id = \(tweetID)")
            TwitterClient.sharedInstance?.postFavorite(tweetID: tweetID, success: { (tweet: Tweet) in
                print("successfully favorited a tweet. I should now send a message to TweetVC to update Favorites count")
                //send delegate message to TweetsViewController so that favorites count should be updated
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if let tweetID = tweet.tweetID {
            print("User clicked the retweet button on tweet id = \(tweetID)")
            TwitterClient.sharedInstance?.postRetweet(tweetID: tweetID, success: { (tweet:Tweet) in
                print("successfully retweeted a tweet. I should now send a message to TweetVC to update retweet count")
                //send delegate message to TweetsViewController so that retweet count should be updated
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
        
    }
    
    // =============================================================
    
    // =============== Update IB Outlets ===========================
    func updateUserDetails() -> Void {
        //Update the User IBOutlets
        let tweetUser = tweet.user
        fullNameLabel.text = tweetUser?.name
        screenNameLabel.text = tweetUser?.screenName
        profilePictureImageView.setImageWith((tweetUser?.profileURL)!)
        
        //Update the Tweet IBOutlets
        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.detailTimeStamp
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
    }
    // =============================================================
    // =============== Cosmetic Methods ============================
    func customizeNavigationBar(){
        
        self.navigationItem.title = "Tweet"
        if let navigationBar = navigationController?.navigationBar {
            
            //Change the color of the Bar button fonts
            navigationBar.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            ]
        }
    }
    // =============================================================
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tweetReplySegue" {
            print("I'm inside the tweetReplySegue")
            let navVC = segue.destination as! UINavigationController
            let tweetReplyVC = navVC.topViewController as! TweetReplyViewController
            //tweetReplyVC.delegate = self
            
            tweetReplyVC.tweetInReplyTo = tweet
        }
    }
    
    
}
