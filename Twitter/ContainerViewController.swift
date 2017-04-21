//
//  ContainerViewController.swift
//  Twitter
//
//  Created by victor rodriguez on 4/19/17.
//  Copyright © 2017 Victor Rodriguez. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var originalLeftMarginConstraint: CGFloat!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var menuViewController: UIViewController! {
        didSet{
            view.layoutIfNeeded() //layoutIfNeeded isn't important here, but by calling the view. property I'm invoking "ViewDidLoad()" which will get run before the next line
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController){
            contentViewController!.view.frame = contentView.bounds
            
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ====================Gesture IB Actions ======================
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("GestureRecognizer BEGAN")
            originalLeftMarginConstraint = leftMarginConstraint.constant
        } else if sender.state == .changed {
            print("GestureRecognizer CHANGED")
            leftMarginConstraint.constant = originalLeftMarginConstraint + translation.x
        } else if sender.state == .ended {
            print("GestureRecognizer ENDED")
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0{
                    print("ended with positive velocity")
                    self.leftMarginConstraint.constant = self.view.frame.width-200
                } else {
                    print("ended with negative velocity")
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
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
