//
//  MentionsViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/21/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        requestMentionsTimeline()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // ============ API Methods ====================================
    func requestMentionsTimeline() -> Void{
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
    // =============================================================
    // ============ Table View Methods =============================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            //print("setting up tweetCells in profile page")
            cell.tweet = tweets[indexPath.row]
            return cell
        
    }
    fileprivate func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    // =============================================================
    // =============== Cosmetic Methods ============================
    func customizeNavigationBar(){

        self.navigationItem.title = "Mentions"
        
        // self.navigationItem.title = "\(tweet.user?.name)"
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
    // ============ Refresh Control Methods ========================
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refresh(sender:AnyObject)
    {
        requestMentionsTimeline()
        print("end refreshing")
        self.refreshControl?.endRefreshing()
    }
    
    fileprivate func addRefreshControl() -> Void{
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfilePageViewController.refresh), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    // =============================================================
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MentionToProfileSegue"{
            print("I'm inside the MentionToProfileSegue")
            let tweetCell = (sender as AnyObject).superview??.superview as! TweetCell
            let tweetIndexPath = tableView.indexPath(for: tweetCell)
            let tweet = tweets[(tweetIndexPath?.row)!]
            
            let profilePageVC = segue.destination as! ProfilePageViewController
            profilePageVC.tweet = tweet
        }
    }
}
