//
//  SettingViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var Save: UIBarButtonItem!
    
    @IBAction func SaveSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
