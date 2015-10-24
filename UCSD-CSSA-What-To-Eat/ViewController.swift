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
    //For displaying "shake me"
    @IBOutlet var shakeLabel: UILabel!
    
    //For displaying the result resturant name
    @IBOutlet weak var button: UIButton!
    //For displaying the result resturant image

    @IBOutlet var Rest_Image: UIButton!
    
    
    @IBOutlet var pc_on: UISwitch!
    
    var i = Int(arc4random_uniform(10))
    var using_pc = true
    var pc_rest = ["Shogun", "Panda", "Tapioca", "Bombay Coast","Lemon Grass","Subway","Santorini","Burger King","Jumba Juice","Dlush"]
    
    var other_rest = ["Perks", "Art of Espresso Café", "Bella Vista Social Club and Caffé",
        "Short Stop",
        "HomePlate",
        "Peets Coffee and Tea",
        "Hi Thai",
        "Sixty-Four Degrees",
        "Sixty-Four North",
        "Cafe Ventanas",
        "Canyon Vista",
        "FoodWorx",
        "Pines",
        "Goodys Coffee Window",
        "Goodys",
        "Roots",
        "The Bistro at The Strand"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pc_on.addTarget(self, action: Selector("switchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            using_pc = true
        } else {
            using_pc = false
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    //For detect motion start event
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake{
        }
    }
    
    //For detecting motion end evenet
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if motion == .MotionShake {
            
            if(using_pc){
                i = Int(arc4random_uniform(UInt32(pc_rest.count)))
                button.setTitle(pc_rest[i], forState: .Normal)
                Rest_Image.setImage(UIImage(named: pc_rest[i] + ".png"), forState: UIControlState.Normal)
            }
            else{
                i = Int(arc4random_uniform(UInt32(other_rest.count)))
                button.setTitle(other_rest[i], forState: .Normal)
                Rest_Image.setImage(UIImage(named: other_rest[i] + ".png"), forState: UIControlState.Normal)
 
            }
            
        }

    }
}

