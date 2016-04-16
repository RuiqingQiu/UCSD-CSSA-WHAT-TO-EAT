//
//  ViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.

import UIKit
import GLKit
import AudioToolbox
var currentListName = "1"


class ViewController: UIViewController {
    var shaked = true
    var cellDescriptors: NSMutableArray!
    var ListNames = ["List 1", "List 2", "List 3", "List 4"];

    @IBOutlet weak var shakeMe: UIImageView!
    @IBOutlet weak var filterButton: UIImageView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var dice: UIImageView!
    
    
    
    //Prevent user from rotating the view
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        icon.iconSize = 0.5*self.view.frame.width
        initMyLayer(getPngSelected())
        self.filterButton.userInteractionEnabled = true
        
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["List 1", "List 2", "List 3", "List 4"];
        }
        
        filterName.text = ListNames[Int(currentListName)! - 1];
        
        //print("viewdidiload")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        print(getPngSelected());
        self.iconview.alpha = 0
        self.shakeMe.alpha = 1
        self.dice.alpha = 1
        updatePool (getPngSelected())
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["List 1", "List 2", "List 3", "List 4"];
        }
        
        filterName.text = ListNames[Int(currentListName)! - 1];

    
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch: UITouch? = touches.first
        if touch?.view == filterButton{
            let FilterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FilterViewController")
            
            self.presentViewController(FilterViewController, animated: true, completion: nil)
        }
        super.touchesEnded(touches, withEvent: event)
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
            if let soundURL = NSBundle.mainBundle().URLForResource("shotgun", withExtension: "mp3") {
                var mySound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(soundURL, &mySound)
                // Play
                AudioServicesPlaySystemSound(mySound);
            }
            self.startAnimation()
        }
    }
    
    
    var icons = [icon]()
    var chosen0 = icon(superframe: CGRect())
    var chosen1 = icon(superframe: CGRect())
    var myLayer = CALayer()
    var blurView = UIVisualEffectView()
    var myview = UIView()
    func initMyLayer(randomPool:Array<resinfo>) -> Void
    {
        icon.randomPool = randomPool
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.insertSubview(blurView, atIndex: 0)
        
        myview = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/2.0))
        
        myLayer.frame = myview.frame
        myview.layer.addSublayer(myLayer)

        self.view.insertSubview(myview, atIndex: 0)
        
        for x in -6...3
        {
            for y in -3...3
            {
                let i = icon(superframe: myview.frame)
                i.shuffle()
                i.x = x
                i.y = y
                icons.append(i)
                myLayer.addSublayer(i.layer)
                if (x==0 && y==0)
                {
                    chosen0 = i
                }
                else if (x == -3 && y==0)
                {
                    chosen1 = i
                }
            }
        }
        
        chosen0.layer.zPosition = 1
        chosen1.layer.zPosition = 1
        
        chosen0.layer.shadowColor = UIColor.blackColor().CGColor
        chosen0.layer.shadowOffset = CGSizeMake(5, 5)
        chosen0.layer.shadowRadius = 5
        
        chosen1.layer.shadowColor = UIColor.blackColor().CGColor
        chosen1.layer.shadowOffset = CGSizeMake(5, 5)
        chosen1.layer.shadowRadius = 5
        
        myview.layer.allowsEdgeAntialiasing = true
        
        let model:GLKMatrix4! = GLKMatrix4Identity
        myLayer.transform = getTransformWithModel(model)
        
        //Icon view is the final big image displayed
        iconview = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/2.0))
        iconview.alpha = 0
        iconviewObj = icon(superframe: iconview.frame)
        iconview.layer.addSublayer(iconviewObj.layer)
        iconviewObj.shuffle()
        self.view.addSubview(iconview)
    }
    
    func getTransformWithModel(model:GLKMatrix4) -> CATransform3D
    {
        let ratio = Float(self.view.frame.width/500)
        let view:GLKMatrix4! = GLKMatrix4MakeLookAt(-100.0*ratio, 300.0*ratio, 400.0*ratio, 0, 0, 0, 0, 0, -1)
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
        
        let cat = CATransform3D(m11: CGFloat(mvp.m00), m12: CGFloat(mvp.m01), m13: CGFloat(mvp.m02), m14: CGFloat(mvp.m03), m21: CGFloat(mvp.m10), m22: CGFloat(mvp.m11), m23: CGFloat(mvp.m12), m24: CGFloat(mvp.m13), m31: CGFloat(mvp.m20), m32: CGFloat(mvp.m21), m33: CGFloat(mvp.m22), m34: CGFloat(mvp.m23), m41: CGFloat(mvp.m30), m42: CGFloat(mvp.m31), m43: CGFloat(mvp.m32), m44: CGFloat(mvp.m33))
        
        return cat
    }
    
    //#TODO call updatePool from filter view
    func updatePool (randomPool:Array<resinfo>) -> Void
    {
        icon.randomPool = randomPool
        for i in icons
        {
            i.shuffle()
        }
    }
    
    var timer = NSTimer()
    
    func startAnimation() -> Void
    {
        frameCount = 0
        iconviewObj.layer.transform = self.getTransformWithModel(GLKMatrix4Identity)
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.iconview.alpha = 0
            self.shakeMe.alpha = 0
            self.dice.alpha = 0}, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.blurView.frame = CGRectMake(0, self.view.frame.height * 0.75, self.view.frame.width, self.view.frame.height * 0.25)}, completion: nil)
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "animationUpdate", userInfo: nil, repeats: true)
    }
    
    var iconview = UIView()
    var iconviewObj = icon(superframe: CGRect())
    
    func stopAnimation() -> Void
    {
        timer.invalidate()
        timer = NSTimer()
        chosen0.dx = 0.0
        chosen0.dy = 0.0
        chosen0.rotate = 0.0
        chosen1.dx = 0.0
        chosen1.dy = 0.0
        chosen1.rotate = 0.0
        if (isMoved)
        {
            iconviewObj.n = chosen1.n
        }
        else
        {
            iconviewObj.n = chosen0.n
        }
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.iconview.alpha = 1
        }
        
        UIView.animateWithDuration(0.3, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.blurView.frame = self.view.frame
            self.shakeMe.alpha = 1}, completion: chosenRotate)
        
    }
    
    func chosenRotate (_: Bool) -> Void
    {
        iconviewObj.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
    }

    func getResult() -> resinfo
    {
        if (isMoved)
        {
            return icon.randomPool[chosen1.n]
        }
        else
        {
            return icon.randomPool[chosen0.n]
        }
    }
    
    var frameCount = 0
    var isMoved = false
    //Function that supports icon moving
    func animationUpdate () -> Void
    {
        
        for i in icons{
            let r = Int(arc4random_uniform(12))
            let dx = Int(arc4random_uniform(400))
            let dy = Int(arc4random_uniform(400))
            i.rotate = CGFloat(r-6)/2
            i.dx = CGFloat(dx)-200
            i.dy = CGFloat(dy)-200
        }
        
        if (frameCount%4 == 0)
        {
            var model = GLKMatrix4Identity
            if(!isMoved)
            {
                model = GLKMatrix4MakeTranslation(750, 0, 0)
            }
            myLayer.transform = getTransformWithModel(model)
            chosen0.shuffle()
            chosen1.shuffle()
            isMoved = !isMoved
        }
        
        frameCount += 1
        if frameCount>14{
            stopAnimation()
        }
        
    }
    
    
    func getPngSelected() -> Array<resinfo>
    {
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileName = "CellDescriptor" +  currentListName + ".plist"
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        let path = fileURL.path!
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle CellDescriptor.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                    print("error")
                }
                //fileManager.copyItemAtPath(bundlePath, toPath: path)
                print("copy")
            } else {
                print("CellDescriptor.plist not found. Please, make sure it is part of the bundle.")
            }
        }
        
        cellDescriptors = NSMutableArray(contentsOfFile: path)
 
        var returnArray = [resinfo]()
        for currentSectionCells in cellDescriptors
        {
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1)
            {
                if ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["cellIdentifier"] as!
                    String == "idItemCell"
                {
                    //print(((currentSectionCells as? NSArray)![row] as? NSDictionary)!["checked"])
                    
                    if ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["checked"] as! Bool == true
                    {
                        
                        let png = ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["png"] as! String
                        
                        let englishName = ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["englishName"] as! String
                        
                        let utf8Name = ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["utf8Name"] as! String
                        
                        let r = resinfo(png:png, englishName:englishName, utf8Name:utf8Name)
                        
                        
                        returnArray.append(r)
                    }
                }
            }
            
        }
    
        return returnArray
    
    }
       
    
}

