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
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        })
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
