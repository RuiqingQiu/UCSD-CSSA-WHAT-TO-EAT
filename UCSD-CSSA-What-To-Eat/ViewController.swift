//
//  ViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.

import UIKit


class ViewController: UIViewController {
    var shaked = true

    //@IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet var shakeLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var i = Int(arc4random_uniform(10))
    var nameArray = ["Shogun", "Panda", "Tapioca", "Bombay Coast","Pines","Santorini","Lemon Grass","Shogun","Shogun","Shogun"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            
            
            i = Int(arc4random_uniform(10))
            button.setTitle(nameArray[i], forState: .Normal)
            
            /*
            shaked = !shaked;
            
            
            
            
            if(!shaked){
                self.shakeLabel.text = "╯' - ')╯︵ ┻━┻"
            }
            else{
                self.shakeLabel.text = " ┬─┬ ノ( ' - 'ノ)"
                
            }
            */
        }
    }
}

