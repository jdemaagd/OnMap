  //
//  BreakpointSettingsViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/17/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - BreakpointSettingsViewController: UIViewController

class BreakpointSettingsViewController: UIViewController {
    
    // MARK: Properties
    
    let bugFactory = BugFactory.sharedInstance()
    
    // MARK: Outlets
    
    @IBOutlet weak var currentBugTypeImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBugTypeImageView.tintColor = BugFactory.bugTints[bugFactory.currentBugType.rawValue]
    }
    
    // MARK: - Actions
    
    @IBAction func dismissSettingsTouched(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bugTypeSelected(_ sender: UIButton) {
        bugFactory.currentBugType = BugFactory.BugType(rawValue: Int(sender.currentTitle!)!)!
        
        // BUG: View was not being dismissed
        // Was setup as 'Show (e.g. Push)' segue:
        // switch to 'Present Modally' segue per docs: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss
        self.dismiss(animated: true, completion: nil)
    }
}
