//
//  ContainerViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/16/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {

    var currentViewController: UIViewController!
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "showHome", sender: nil)
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func showView(_ segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !self.childViewControllers.contains(segue.destination) {
            // lazy load the child view controller when the first segue to it will take place
            self.addChildViewController(segue.destination)
            currentViewController = segue.destination
            segue.destination.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(segue.destination.view)
            segue.destination.didMove(toParentViewController: self)
        }
        
        if currentViewController == segue.destination {
            // do nothing
        } else {
            doSegue(currentViewController, toVC: segue.destination)
        }
    }
    
    func doSegue(_ fromVC: UIViewController, toVC: UIViewController) {
        toVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        fromVC.willMove(toParentViewController: nil)
        self.addChildViewController(toVC)
        self.transition(from: fromVC, to: toVC, duration: 0.0, options: UIViewAnimationOptions(), animations: nil, completion: nil)
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
