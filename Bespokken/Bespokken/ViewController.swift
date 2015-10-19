//
//  ViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/10/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var containerViewController: ContainerViewController!
    var homeViewController: HomeViewController!
    var toolbarButtons = [UIButton]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnDayNight: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnShortCodes: UIButton!
    @IBOutlet weak var btnSpacebar: UIButton!
    
    
    @IBAction func onHomeTapped(sender: AnyObject) {
        self.containerViewController.showView("showHome")
    }
    @IBAction func onDayNightTapped(sender: AnyObject) {
        
    }
    
    @IBAction func onHistoryTapped(sender: AnyObject) {
        self.containerViewController.showView("showHistory")
    }
    
    @IBAction func onShortCodesTapped(sender: AnyObject) {
        self.containerViewController.showView("showShortCodes")
    }
    
    @IBAction func onSpacebarTapped(sender: AnyObject) {
        // Notify the Home view that spacebar was tapped
        self.homeViewController.onSpacebarTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for vc in self.childViewControllers {
            print("view Controller: \(vc.title)")
            if vc.title == "Container" {
                self.containerViewController = vc as? ContainerViewController
                for cvc in self.containerViewController.childViewControllers {
                    print("child view controller: \(cvc.title)")
                    if cvc.title == "Home" {
                        self.homeViewController = cvc as? HomeViewController
                    }
                }
            }
        }
        
        toolbarButtons += [btnHome, btnDayNight, btnHistory, btnShortCodes, btnSpacebar]
        
        for button in toolbarButtons {
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.containerViewController = segue.destinationViewController as? ContainerViewController
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }

}

