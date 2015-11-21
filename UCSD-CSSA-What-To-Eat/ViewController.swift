//
//  ViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.

import UIKit
import GLKit


class ViewController: UIViewController {
    
    var subl = CALayer()
    var icons = [icon]()

    
    var shaked = true

    //@IBOutlet weak var shakeLabel: UILabel!
    //For displaying "shake me"
    @IBOutlet var shakeLabel: UILabel!
    
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
        //pc_on.addTarget(self, action: Selector("switchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        //json_helper();
        initMyLayer()
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            using_pc = true
        } else {
            using_pc = false
        }
    }

    func json_helper(){
        let string = "[{\"Name\":\"Shogun\",\"Nickname\":\"将军\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 10:00 - 21:00; Sat/Sun 11:30 - 20:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Asian\",\"Reservation\":null},{\"Name\":\"Panda Express\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th 9:00 – 10:00; Fri 9:00 - 20:00 Sat: 11:00 - 19:00; Sun 11:00 - 19:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Chinese, Asian\",\"Reservation\":null},{\"Name\":\"Tapioca Express\",\"Nickname\":\"Tapioca\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 9:30 - 24:00; Sat/Sun 11:00 - 24:00\",\"DD\":0,\"Discount\":1,\"Type\":\"Drinks&Snacks, Asian\",\"Reservation\":null},{\"Name\":\"Bombay Coast\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 10:00 – 21:00; Sat 10:00 – 19:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Indian, Curry\",\"Reservation\":null},{\"Name\":\"Lemon Grass\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"\",\"DD\":0,\"Discount\":0,\"Type\":\"Thai/Asian\",\"Reservation\":null},{\"Name\":\"Subway\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 7:00 – 23:00; Sat 8:00 – 23:00; Sun 9:30 – 23:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Sandwich\",\"Reservation\":null},{\"Name\":\"Santorini\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 7:30 – 23:00; Sat 10:00 – 18:00; Sun 12:00 - 20:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Junk food\",\"Reservation\":null},{\"Name\":\"Burger King\",\"Nickname\":\"BK\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 0:00 - 24:00; Sat 8:00 – 24:00; Sun 9:30 – 24:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Junk food, Burger\",\"Reservation\":null},{\"Name\":\"Jumba Juice\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th/F 7:00 – 22:00; Sat 9:30 – 16:00; Sun 9:30 – 16:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Drink\",\"Reservation\":null},{\"Name\":\"Dlush\",\"Nickname\":\"\",\"Location\":\"Price Center\",\"Hours\":\"M/T/W/Th 8:00 – 23:00; F/Sat 8:00 – 21:00; Sun 11:00 – 23:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Drink&Snack, Breakfast\",\"Reservation\":null},{\"Name\":\"Perks\",\"Nickname\":\"\",\"Location\":\"BookStore\",\"Hours\":\"M/T/W/Th 7:00 – 19:00; F 7:00 – 18:00; Sat/Sun 12:00 – 17:00; Summer M/T/W/Th/F 7:00 – 18:00; Sat 12:00 – 17:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Drink&Snack\",\"Reservation\":null},{\"Name\":\"Art of Espresso Café\",\"Nickname\":\"N/A\",\"Location\":\"Mandeville Center \",\"Hours\":\"M/T/W/Th/F 7:00 - 16:00\",\"DD\":0,\"Discount\":0,\"Type\":\"Drink&Snack\",\"Reservation\":null},{\"Name\":\"Bella Vista Social Club and Caffé \",\"Nickname\":\"N/A\",\"Location\":\"Sanford Consortium \",\"Hours\":\"M/T/W/Th/F 7:30 - 21:00; SatSun 8:00 - 15:00\",\"DD\":0,\"Discount\":0,\"Type\":\"?\",\"Reservation\":null},{\"Name\":\"Short Stop\",\"Nickname\":\"N/A\",\"Location\":\"RIMAC ANNEX\",\"Hours\":\"M-F 8AM-7PM, SAT 9AM-4PM\",\"DD\":0,\"Discount\":0,\"Type\":\"Breakfast & Snack\",\"Reservation\":null},{\"Name\":\"HomePlate\",\"Nickname\":\"N/A\",\"Location\":\"RIMAC ANNEX\",\"Hours\":\"Weekdays: 11 a.m. – Midnight, Sun: 11 a.m. – 7 p.m. or end of game\",\"DD\":0,\"Discount\":0,\"Type\":\"Cafe&Bar\",\"Reservation\":null},{\"Name\":\"Peets Coffee and Tea\",\"Nickname\":\"N/A\",\"Location\":\"RIMAC ANNEX\",\"Hours\":\"M-Th 7am-9pm, F 7am-6pm, Sat 8am-2pm, Sun 10am-2pm\",\"DD\":0,\"Discount\":0,\"Type\":\"Drink&Snack\",\"Reservation\":null},{\"Name\":\"Hi Thai\",\"Nickname\":\"N/A\",\"Location\":\"Student Center\",\"Hours\":\"Weekdays 8am - 9pm\",\"DD\":0,\"Discount\":0,\"Type\":\"Thai/Asian\",\"Reservation\":null},{\"Name\":\"64 Degrees\",\"Nickname\":\"64度\",\"Location\":\"Revelle\",\"Hours\":\"M/T/W/Th 10:00 - 21:00; F/Sun 10:00 - 20:00\",\"DD\":1,\"Discount\":0,\"Type\":\"Dining hall\",\"Reservation\":null},{\"Name\":\"Sixty-Four Norh\",\"Nickname\":\"64北\",\"Location\":\"Revelle\",\"Hours\":\"M-F 11am-2pm\",\"DD\":1,\"Discount\":0,\"Type\":\"好像是正餐(似乎比bistro还要高端？）http://hdh.ucsd.edu/DiningMenus/default.aspx?i=65\",\"Reservation\":\"858-822-6899\"},{\"Name\":\"Cafe Ventanas\",\"Nickname\":\"ERC 食堂\",\"Location\":\"ERC\",\"Hours\":\"Mon - Thurs: 7:30 am - 9 pm; Fri: 7:30 am - 8 pm; Sat - Sun: 10 am - 8 pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Dining hall\",\"Reservation\":null},{\"Name\":\"Canyon Vista\",\"Nickname\":\"CV （Warren 食堂【。\",\"Location\":\"Warren\",\"Hours\":\"Mon - Thurs: 7:30 am - 9 pm; Fri: 7:30 am - 8 pm; Sat - Sun: 10 am - 8 pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Dining hall\",\"Reservation\":null},{\"Name\":\"Foodworx\",\"Nickname\":\"Sixth 食堂\",\"Location\":\"Sixth\",\"Hours\":\"Mon - Thurs: 7:30 am - 9 pm; Fri: 7:30 am - 8 pm; Sat - Sun: 10 am - 8 pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Pizza&Salad (Dinnning hall)\",\"Reservation\":null},{\"Name\":\"Pines\",\"Nickname\":\"Pines\",\"Location\":\"Muir\",\"Hours\":\"Mon - Thurs: 7:30 am - 9 pm; Fri: 7:30 am - 8 pm; Sat - Sun: 10 am - 8 pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Dinning hall\",\"Reservation\":null},{\"Name\":\"Goodys Coffee Window\",\"Nickname\":\"Goodys\",\"Location\":\"Marshall\",\"Hours\":\"M-F 7am - 8pm; Sat - Sun 11am - 8pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Drinks&Snack\",\"Reservation\":null},{\"Name\":\"Goodys\",\"Nickname\":\"Goodys\",\"Location\":\"Marshall\",\"Hours\":\"M-F 8am-10pm; Sat-Sun 11am-10pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Burrito\",\"Reservation\":null},{\"Name\":\"Roots\",\"Nickname\":\"N/A\",\"Location\":\"Muir\",\"Hours\":\"M-F 11am-8pm\",\"DD\":1,\"Discount\":0,\"Type\":\"Vegeterian\",\"Reservation\":null},{\"Name\":\"The Bistro at The Strand\",\"Nickname\":\"Bistro\",\"Location\":\"The Village East\",\"Hours\":\"M/T/W/Th 10:00 - 21:00; F/Sun 10:00 - 20:00\",\"DD\":1,\"Discount\":0,\"Type\":\"?\",\"Reservation\":\"858-822-4275\"}]";
        
        func JSONParseArray(string: String) -> [AnyObject]{
            if let data = string.dataUsingEncoding(NSUTF8StringEncoding){
                
                do{
                    
                    if let array = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)  as? [AnyObject] {
                        return array
                    }
                }catch{
                    
                    print("error")
                    //handle errors here
                    
                }
            }
            return [AnyObject]()
        }
        
        
        
        for element: AnyObject in JSONParseArray(string) {
            let name = element["Name"] as? String
            let nickname = element["Nickname"] as? String
            let location = element["Location"] as? String
            let hours = element["Hours"] as? String
            let isDiningDollor = element["DD"] as? Int
            let hasDiscount = element["Discount"] as? Int
            let type = element["Type"] as? String
            let reservation = element["Reservation"] as? String
            print("Name: \(name), Nickname: \(nickname), Location: \(location), Hours: \(hours), Can use dining dollor: \(isDiningDollor), Discount: \(hasDiscount), Type: \(type), Reservation: \(reservation)\n")
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
                Rest_Image.setImage(UIImage(named: pc_rest[i] + ".png"), forState: UIControlState.Normal)
            }
            else{
                i = Int(arc4random_uniform(UInt32(other_rest.count)))
                Rest_Image.setImage(UIImage(named: other_rest[i] + ".png"), forState: UIControlState.Normal)
 
            }
            
        }

    }
    
    
    func initMyLayer() -> Void
    {
        subl.frame = self.view.frame
        
        self.view.layer.addSublayer(subl)
        
        for x in -10...10
        {
            for y in -10...10
            {
                let i = icon(superframe: self.view.frame)
                let n = Int(arc4random_uniform(12)+1)
                let s = String(format: "Images/%d.png", n)
                i.setImageWithFile(s)
                i.x = x
                i.y = y
                icons.append(i)
                subl.addSublayer(i.view)
            }
        }
        NSLog(NSStringFromCGRect(self.subl.frame))
        
        /*let img = UIImage(named: "Images/1.png")
        /*let view = UIImageView(image: img)
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.view.addSubview(view)*/
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = 0
        
        let outputImage = blurFilter.imageByFilteringImage(img)
        /*let view2 = UIImageView(image: outputImage)
        view2.frame = CGRect(x: 0, y: 300, width: 300, height: 300)
        self.view.addSubview(view2)*/
        
        sublu.contents=img!.CGImage
        sublu.frame = CGRect(x: 0.5*self.view.frame.width-125, y: 0.5*self.view.frame.height-125, width: 250, height: 250)
        //sublu.frame = self.view.frame
        //subl.frame = CGRect(x: 0, y: 0, width: 250, height: 250)*/
        subl.allowsEdgeAntialiasing = true
        //subl.addSublayer(sublu)
        //sublu.addSublayer(subl)
        
        //subl.transform = CATransform3DMakeRotation(3.14,0,0,1)
        //subl.transform = CATransform3DMakeAffineTransform(CGAffineTransformMake(1.0, 0.0, 0.2, 0.9, 0.0, 0.0));
        
        /*NSLog("view")
        var RESULT:GLKMatrix4! = view
        NSLog("    %f %f %f %f",RESULT.m00,RESULT.m01,RESULT.m02,RESULT.m03);
        NSLog("    %f %f %f %f",RESULT.m10,RESULT.m11,RESULT.m12,RESULT.m13);
        NSLog("    %f %f %f %f",RESULT.m20,RESULT.m21,RESULT.m22,RESULT.m23);
        NSLog("    %f %f %f %f",RESULT.m30,RESULT.m31,RESULT.m32,RESULT.m33);*/
        
        
        let model:GLKMatrix4! = GLKMatrix4MakeTranslation(0, 0, 0)
        let view:GLKMatrix4! = GLKMatrix4MakeLookAt(-100, 300, 400, 0, 0, 0, 0, 0, -1)
        let perspective:GLKMatrix4! = GLKMatrix4MakePerspective(Float(0.3 * M_PI), 1, 0.1, 10.0)
        var ts:GLKMatrix4!
        ts = GLKMatrix4MakeScale(2.0/Float(self.view.frame.width), 2.0/Float(self.view.frame.width), 2.0/Float(self.view.frame.width))
        let tsi:GLKMatrix4! = GLKMatrix4Invert(ts, nil)
        var mvp:GLKMatrix4! = GLKMatrix4Identity
        
        
        mvp = GLKMatrix4Multiply(model, mvp)
        mvp = GLKMatrix4Multiply(view, mvp)
        
        mvp = GLKMatrix4Multiply(ts, mvp)
        
        mvp = GLKMatrix4Multiply(perspective, mvp)
        mvp = GLKMatrix4Multiply(tsi, mvp)
        
        var cat:CATransform3D!
        
        cat = CATransform3D(m11: CGFloat(mvp.m00), m12: CGFloat(mvp.m01), m13: CGFloat(mvp.m02), m14: CGFloat(mvp.m03), m21: CGFloat(mvp.m10), m22: CGFloat(mvp.m11), m23: CGFloat(mvp.m12), m24: CGFloat(mvp.m13), m31: CGFloat(mvp.m20), m32: CGFloat(mvp.m21), m33: CGFloat(mvp.m22), m34: CGFloat(mvp.m23), m41: CGFloat(mvp.m30), m42: CGFloat(mvp.m31), m43: CGFloat(mvp.m32), m44: CGFloat(mvp.m33))
        
        subl.transform = cat
    }
}

