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
    @IBOutlet weak var btnSpacebarRight: UIButton!
    
    
    @IBAction func onHomeTapped(_ sender: AnyObject) {
        self.containerViewController.showView("showHome")
    }
    @IBAction func onDayNightTapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func onHistoryTapped(_ sender: AnyObject) {
        self.containerViewController.showView("showHistory")
    }
    
    @IBAction func onShortCodesTapped(_ sender: AnyObject) {
        self.containerViewController.showView("showShortCodes")
    }
    
    @IBAction func onSpacebarTapped(_ sender: AnyObject) {
        doSpacebar()
    }
    
    @IBAction func onSpacebarRightTapped(_ sender: AnyObject) {
        doSpacebar()
    }
    
    func doSpacebar() {
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
        
        toolbarButtons += [btnHome, btnDayNight, btnHistory, btnShortCodes, btnSpacebar, btnSpacebarRight]
        
        for button in toolbarButtons {
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.containerViewController = segue.destination as? ContainerViewController
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }

}

