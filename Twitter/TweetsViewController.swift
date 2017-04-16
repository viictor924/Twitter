//
//  TweetsViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/14/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
       // tableView.estimatedRowHeight = 100
       // tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            print("printing all the tweets")
            self.tableView.reloadData()
            for tweet in tweets {
                print(tweet.text)
            }
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogoutButton(_ sender: Any) {
        
        print("User clicked the logOut button")
        TwitterClient.sharedInstance?.logOut()
        User.currentUser = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.tweetTextLabel.text = tweet.text as String?
        cell.timestampLabel.text = tweet.timeStampString as String?
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoritesCountLabel.text = "\(tweet.favoritesCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
