//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/15/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var newTweetTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // input user details into labels and imageViews
        updateUserDetails()
        
        newTweetTextField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserDetails() -> Void {
        if let currentUser = User.currentUser {
        fullNameLabel.text = currentUser.name
        screenNameLabel.text = currentUser.screenName
        profilePictureImageView.setImageWith(currentUser.profileURL!)
        }
    }

    
    @IBAction func onTweetButton(_ sender: Any) {
        print("Submitting tweet: \(newTweetTextField.text)")
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
