//
//  TweetsViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/14/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureRowHeight()
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let navVC = storyboard.instantiateViewController(withIdentifier: "NewTweetViewController") as! UINavigationController
         let newTweetVC = navVC.topViewController as! NewTweetViewController
         newTweetVC.delegate = self
         */
        addRefreshControl()
        requestHomeTimeline()
        
        //Customize the Navigation Bar
        customizeNavigationBar()
    }
    // ============ API Methods =============================
    func requestHomeTimeline() -> Void{
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            print("printing all the tweets")
            self.tableView.reloadData()
            
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
    // ======================================================
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ============ IB Action Methods =============================
    @IBAction func onLogoutButton(_ sender: Any) {
        
        print("User clicked the logOut button")
        TwitterClient.sharedInstance?.logOut()
        User.currentUser = nil
    }
    
    // =============================================================
    // ============ Table View Methods =============================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    // =============================================================
    // ============ Refresh Control Methods ========================
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refresh(sender:AnyObject)
    {
        requestHomeTimeline()
        print("end refreshing")
        self.refreshControl?.endRefreshing()
    }
    
    fileprivate func addRefreshControl() -> Void{
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refresh), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    // =============================================================
    
    // =============== Cosmetic Methods ============================
    func customizeNavigationBar(){
        
        self.navigationItem.title = "Home"
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    // =============== Prepare for Segue ============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "newTweetSegue" {
            let navVC = segue.destination as! UINavigationController
            let newTweetVC = navVC.topViewController as! NewTweetViewController
            newTweetVC.delegate = self
        }
            
        else if segue.identifier == "tweetDetailSegue"{
            let tweetCell = sender as! TweetCell
            let tweetIndexPath = tableView.indexPath(for: tweetCell)
            let tweet = tweets[(tweetIndexPath?.row)!]
            print("I'm inside the tweetDetailSegue")
            
            //let navVC = segue.destination as! UINavigationController
            //let tweetDetailVC = navVC.topViewController as! TweetDetailViewController
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC.tweet = tweet
        }
        else if segue.identifier == "profilePageSegue"{
            print("I'm inside the profilePageSegue")
            let tweetCell = (sender as AnyObject).superview??.superview as! TweetCell
            let tweetIndexPath = tableView.indexPath(for: tweetCell)
            let tweet = tweets[(tweetIndexPath?.row)!]
            
            //let navVC = segue.destination as! UINavigationController
            //let profilePageVC = navVC.topViewController as! ProfilePageViewController
            let profilePageVC = segue.destination as! ProfilePageViewController
            profilePageVC.tweet = tweet
        }
    }
    // =============================================================
}
// =============== Delegate Methods ============================
// MARK: - NewTweetControllerDelegate
extension TweetsViewController: newTweetControllerDelegate {
    func newTweetComposed(newTweetViewController: NewTweetViewController, didPostTweet tweet: Tweet) {
        print("newTweetComposed delegate called on TweetsViewController")
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
   // func tweetReply
}
// =============================================================
