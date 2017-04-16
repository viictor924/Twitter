//
//  TweetsViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/14/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        configureRowHeight()
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            print("printing all the tweets")
            self.tableView.reloadData()

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
    // ============ Table View Methods ========================
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
    // ========================================================
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
}

