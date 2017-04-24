//
//  MenuViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/19/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var tweetsNavigationController: UINavigationController!
    fileprivate var profileNavigationController: UINavigationController!
    fileprivate var mentionsNavigationController: UINavigationController!
    
    var menuLabels = ["Profile", "Timeline", "Mentions"]
    
    var viewControllers: [UIViewController] = []
    var containerViewController: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        configureRowHeight()
        
        print("ViewDidLoad: MenuViewController")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController") as! UINavigationController
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        containerViewController?.contentViewController = tweetsNavigationController
    }
    
    // ============ Table View Methods =============================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuLabel.text = menuLabels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
        }
        containerViewController.contentViewController = viewControllers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func configureRowHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    // =============================================================
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
