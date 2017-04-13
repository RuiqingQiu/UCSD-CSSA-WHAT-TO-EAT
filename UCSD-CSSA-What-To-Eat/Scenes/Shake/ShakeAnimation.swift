//
//  ShakeAnimation.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by zinsser on 10/30/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import UIKit
import GLKit

//  A struct contains restaurant info
struct Resinfo
{
    // png file name that can be passed to UIImage(png)
    var png = ""
    
    // restaurant name
    var englishName = ""
    
    // restaurant utf8 name (Chinese, Korean, Japanese)
    var utf8Name = ""
    
    init(png: String, englishName: String, utf8Name:String)
    {
        self.png = png
        self.englishName = englishName
        self.utf8Name = utf8Name
    }
}

// Each icon on the Shake view is an instance of this class
fileprivate class Icon
{
    // An array of Resinfo that contains all the restaurants to be chosen from
    static var randomPool:[Resinfo] = [Resinfo]()
    
    // Icon size
    static var iconSize:CGFloat = 200.0
    {
        didSet
        {
            doubleIconSize = UInt32(2 * iconSize)
            displacement = 0.625 * iconSize
        }
    }
    
    // Doubled icon size. For optimize purpose
    static var doubleIconSize:UInt32 = 400
    
    // Displacement of adjacent rows (same y) in x direction
    static var displacement:CGFloat = 125.0

    
    // Layer of the instance
    var layer = CALayer()

    // Return chosen restaurant Resinfo object
    var res:Resinfo
    {
        get
        {
            return Icon.randomPool[n]
        }
    }
    
    // Index of chosen restaurant of the randomPool
    var n = 0
    {
        didSet
        {
            if n < Icon.randomPool.count {
                self.setImage(Resinfo: Icon.randomPool[n])
            }
        }
    }
    
    // randomly chosen one restaurant from the randomPool
    func shuffle() -> Void
    {
        n = Int(arc4random_uniform(UInt32(Icon.randomPool.count)))
    }
    
    // After set x, y, please call undateMajorTransform()
    // x index
    var x:Int = 0
    
    // y index
    var y:Int = 0
    
    // Major transofrm matrix based on x, y
    var majorTransform: CATransform3D = CATransform3DIdentity
    
    // Function to update major transform matrix
    func updateMajorTransform() -> Void
    {
        majorTransform = CATransform3DTranslate(CATransform3DIdentity, CGFloat(x) * Icon.iconSize * 1.25 + (y%2 == 0 ? 0 : Icon.displacement), CGFloat(y) * Icon.iconSize * 1.25, 0)
        updateTransform()
    }
    
    // After set dx, dy, rotate, please call undateTransform()
    // Didn't use didset trap function because dx, dy, rotate may be changed at the same time.
    
    // shaking x index displacement
    var dx:CGFloat = 0.0
    
    // shaking y index displacement
    var dy:CGFloat = 0.0
    
    // rotate angle
    var rotate:CGFloat = 0.0
    
    // Function to update transform matrix based on dx, dy, rotate
    func updateTransform() -> Void
    {
        var t = majorTransform
        t = CATransform3DTranslate(t, dx, dy, 0)
        t = CATransform3DRotate(t, rotate, 0, 0, 1.0)
        self.layer.transform = t
    }
    
    init(superFrame:CGRect, x:Int, y:Int)
    {
        layer.frame = CGRect(x: 0.5 * superFrame.width - 0.5 * Icon.iconSize, y: 0.5 * superFrame.height - 0.5 * Icon.iconSize, width: Icon.iconSize, height: Icon.iconSize)
        layer.allowsEdgeAntialiasing = true
        
        self.x = x
        self.y = y
        updateMajorTransform()
    }
    
    convenience init(superFrame:CGRect)
    {
        self.init(superFrame: superFrame, x: 0, y: 0)
    }
    
    init()
    {
        //Null init just to make compiler happy
    }
    
    func setImage (file:String) -> Void
    {
        let i = UIImage(named: file)
        self.layer.contents =  i?.cgImage
    }
    
    func setImage (Resinfo:Resinfo) -> Void
    {
        setImage(file: Resinfo.png)
    }
    
    func wander () -> Void
    {
        rotate = CGFloat(Int(arc4random_uniform(12)) - 6) / 2
        dx = CGFloat(arc4random_uniform(Icon.doubleIconSize)) - Icon.iconSize
        dy = CGFloat(arc4random_uniform(Icon.doubleIconSize)) - Icon.iconSize
        updateTransform()
    }
}

// ShakeAnimation class
class ShakeAnimation
{
    unowned var superViewController: ViewController
    var superView: UIView
    {
        get
        {
            return superViewController.view
        }
    }
    
    var myView = UIView()
    var myLayer = CALayer()
    fileprivate var icons = [Icon]()
    fileprivate var chosen0 = Icon()
    fileprivate var chosen1 = Icon()
    
    var blurView = UIVisualEffectView()
    
    var iconView = UIView()
    fileprivate var iconViewObj = Icon()
    
    var timer = Timer()
    var frameCount = 0
    var isMoved = false
    
    var callback : ((Resinfo) -> Void)? = nil
    
    init (superViewController: ViewController, randomPool: [Resinfo])
    {
        self.superViewController = superViewController
        let superFrame = superView.frame
        let focusFrame = CGRect(x: superFrame.origin.x, y: superFrame.origin.y, width: superFrame.size.width, height: superFrame.size.height / 2.0)
        Icon.randomPool = randomPool
        Icon.iconSize = 0.4 * superFrame.width
    
        /******************************
                blurView
         ******************************/
        blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurView.frame = superFrame
        superView.insertSubview(blurView, at: 0)
        
        /******************************
                myView
         ******************************/
        myView = UIView(frame: focusFrame)
        superView.insertSubview(myView, at: 0)
        
        myLayer = CALayer()
        myLayer.frame = focusFrame
        myView.layer.addSublayer(myLayer)
        
        for x in -6...3
        {
            for y in -3...3
            {
                let i = Icon(superFrame: focusFrame, x: x, y: y)
                i.shuffle()
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
        
        chosen0.layer.shadowColor = UIColor.black.cgColor
        chosen0.layer.shadowOffset = CGSize(width: 5, height: 5)
        chosen0.layer.shadowRadius = 5
        
        chosen1.layer.shadowColor = UIColor.black.cgColor
        chosen1.layer.shadowOffset = CGSize(width: 5, height: 5)
        chosen1.layer.shadowRadius = 5
        
        myView.layer.allowsEdgeAntialiasing = true
        myLayer.transform = getTransform(model: GLKMatrix4Identity)
        
        /******************************
                iconView
         ******************************/
        iconView.frame = focusFrame
        iconView.alpha = 0
        iconViewObj = Icon(superFrame: focusFrame)
        iconView.layer.addSublayer(iconViewObj.layer)
        superView.addSubview(iconView)
    }
    
    func updatePool (_ randomPool:[Resinfo]) -> Void
    {
        Icon.randomPool = randomPool
        for i in icons
        {
            i.shuffle()
        }
    }
    
    func shake(callback: ((Resinfo) -> Void)?)
    {
        self.callback = callback
        startAnimation()
    }
    
    func shake() -> Void
    {
        self.callback = nil
        startAnimation()
    }
    
    func getResult() -> Resinfo
    {
        return isMoved ? chosen1.res : chosen0.res
    }
    
    func resetView() -> Void
    {
        iconView.alpha = 0
    }
    
    // MARK: - Private Helpers
    
    private func getTransform(model:GLKMatrix4) -> CATransform3D
    {
        let ratio = Float(superView.frame.width/500)
        let view:GLKMatrix4 = GLKMatrix4MakeLookAt(-100.0*ratio, 300.0*ratio, 400.0*ratio, 0, 0, 0, 0, 0, -1)
        let perspective:GLKMatrix4! = GLKMatrix4MakePerspective(Float(0.3 * M_PI), 1, 0.1, 10.0)
        var ts:GLKMatrix4
        ts = GLKMatrix4MakeScale(2.0/Float(superView.frame.width), 2.0/Float(superView.frame.width), 2.0/Float(superView.frame.width))
        let tsi:GLKMatrix4 = GLKMatrix4Invert(ts, nil)
        var mvp:GLKMatrix4 = GLKMatrix4Identity
        
        mvp = GLKMatrix4Multiply(model, mvp)
        mvp = GLKMatrix4Multiply(view, mvp)
        
        mvp = GLKMatrix4Multiply(ts, mvp)
        
        mvp = GLKMatrix4Multiply(perspective, mvp)
        mvp = GLKMatrix4Multiply(tsi, mvp)
        
        let cat = CATransform3D(m11: CGFloat(mvp.m00), m12: CGFloat(mvp.m01), m13: CGFloat(mvp.m02), m14: CGFloat(mvp.m03), m21: CGFloat(mvp.m10), m22: CGFloat(mvp.m11), m23: CGFloat(mvp.m12), m24: CGFloat(mvp.m13), m31: CGFloat(mvp.m20), m32: CGFloat(mvp.m21), m33: CGFloat(mvp.m22), m34: CGFloat(mvp.m23), m41: CGFloat(mvp.m30), m42: CGFloat(mvp.m31), m43: CGFloat(mvp.m32), m44: CGFloat(mvp.m33))
        
        return cat
    }
    
    private func startAnimation() -> Void
    {
        frameCount = 0
        iconViewObj.layer.transform = getTransform(model: GLKMatrix4Identity)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:
            {
                self.iconView.alpha = 0
                self.superViewController.shakeMe.alpha = 0
                self.superViewController.dice.alpha = 0
                self.superViewController.selectedName.alpha = 0
                self.superViewController.utf8Name.alpha = 0
            }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:
            {
                self.blurView.frame = CGRect(x: 0, y: self.superView.frame.height * 0.75, width: self.superView.frame.width, height: self.superView.frame.height * 0.25)
            }, completion: nil)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ShakeAnimation.animationUpdate), userInfo: nil, repeats: true)
    }
    
    private func stopAnimation() -> Void
    {
        timer.invalidate()
        timer = Timer()
        chosen0.dx = 0.0
        chosen0.dy = 0.0
        chosen0.rotate = 0.0
        chosen1.dx = 0.0
        chosen1.dy = 0.0
        chosen1.rotate = 0.0
        chosen0.updateTransform()
        chosen1.updateTransform()
        
        let chosen = isMoved ? chosen1 : chosen0
        iconViewObj.n = chosen.n
        superViewController.selectedName.text = chosen.res.englishName
        superViewController.utf8Name.text = chosen.res.utf8Name
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time)
        {
            self.iconView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations:
            {
                self.blurView.frame = self.superView.frame
            }, completion: chosenRotate)
        
    }
    
    private func chosenRotate (_: Bool) -> Void
    {
        iconViewObj.layer.transform = CATransform3DMakeScale(1.24, 1.24, 1)
        UIView.animate(withDuration: 0.5, animations:
            {
                self.superViewController.selectedName.alpha = 1
                self.superViewController.utf8Name.alpha = 1
            })
        self.callback?(iconViewObj.res)
    }

    @objc private func animationUpdate () -> Void
    {
        
        for i in icons
        {
            i.wander()
        }
        
        if (frameCount%4 == 0)
        {
            let model = isMoved ? GLKMatrix4Identity : GLKMatrix4MakeTranslation(Float(Icon.iconSize) * 3.75, 0, 0)

            myLayer.transform = getTransform(model: model)
            chosen0.shuffle()
            chosen1.shuffle()
            isMoved = !isMoved
        }
        
        frameCount += 1
        
        if frameCount>14
        {
            stopAnimation()
        }
    }
}
