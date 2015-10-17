//
//  ContainerViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/16/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

public class ContainerViewController: UIViewController {

    var currentViewController: UIViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        performSegueWithIdentifier("showHome", sender: nil)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func showView(segueIdentifier: String) {
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !self.childViewControllers.contains(segue.destinationViewController) {
            // lazy load the child view controller when the first segue to it will take place
            self.addChildViewController(segue.destinationViewController)
            currentViewController = segue.destinationViewController
            segue.destinationViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            self.view.addSubview(segue.destinationViewController.view)
            segue.destinationViewController.didMoveToParentViewController(self)
        }
        
        if currentViewController == segue.destinationViewController {
            // do nothing
        } else {
            doSegue(currentViewController, toVC: segue.destinationViewController)
        }
    }
    
    func doSegue(fromVC: UIViewController, toVC: UIViewController) {
        toVC.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        fromVC.willMoveToParentViewController(nil)
        self.addChildViewController(toVC)
        self.transitionFromViewController(fromVC, toViewController: toVC, duration: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: nil, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
