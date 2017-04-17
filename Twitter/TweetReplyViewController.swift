//
//  TweetReplyViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/16/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class TweetReplyViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var newTweetTextField: UITextField!
    
    var tweetInReplyTo: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // input user details into labels and imageViews
        updateUserDetails()
        
        //Make text field the first responder so keyboard appears
        newTweetTextField.becomeFirstResponder()
        
        customizeNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =============== Update IB Outlets ===========================
    func updateUserDetails() -> Void {
        if let currentUser = User.currentUser {
            fullNameLabel.text = currentUser.name
            screenNameLabel.text = currentUser.screenName
            profilePictureImageView.setImageWith(currentUser.profileURL!)
        }
    }
    // =============================================================
    // =============== IB Action Methods ===========================
    
    
    @IBAction func onReplyButton(_ sender: Any) {
        let message = newTweetTextField.text ?? ""
        print("user clicked onTweetButton")
        
        TwitterClient.sharedInstance?.postReply(tweetMessage: message, tweetInResponseTo: tweetInReplyTo, success: { (tweet:Tweet) in
            print("successfully replied to tweet: \(tweet.text)")
            self.newTweetTextField.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }

    // =============================================================
    // =============== Cosmetic Methods ============================
    func customizeNavigationBar(){
        
        self.navigationItem.title = "New reply"
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

}
