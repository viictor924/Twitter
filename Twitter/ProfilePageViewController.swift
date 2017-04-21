//
//  ProfilePageViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/18/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var tweet: Tweet!
    var tweets: [Tweet]!
    var user = User.currentUser!
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        configureRowHeight()
        customizeNavigationBar()
        addRefreshControl()
        
        requestUserTimeline()
        requestCurrentAccount()
        
        if tweet != nil{
            user = tweet.user!
        }
        
        print("I'm inside ViewDidLoad of profilePage: \(user.name)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ============ API Call Methods =============================
    func requestCurrentAccount() -> Void{
        print("Inside requestCurrentAccount()")
        TwitterClient.sharedInstance?.currentAccount(success: { (user) in
            self.user = user
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func requestUserTimeline() -> Void{
        print("Inside requestUserTimeline()")
        TwitterClient.sharedInstance?.userTimeline(user: user,success: { (tweets:[Tweet]) in
            self.tweets = tweets
           // print("printing \(self.user.screenName)'s tweets")
           // print("\(tweets)")
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
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            print("Setting up user info on profile page")
            //cell.user = tweet.user
            cell.user = user
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            //print("setting up tweetCells in profile page")
            cell.tweet = tweets[indexPath.row-1]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    // =============================================================
    // =============== Cosmetic Methods ============================
    func customizeNavigationBar(){
        
      /*  if let userName = tweet.user?.name{
           self.navigationItem.title = "\(userName)"
        } */
        if let userName = user.name{
            self.navigationItem.title = "\(userName)"
        }
        
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
        requestUserTimeline()
        requestCurrentAccount()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
