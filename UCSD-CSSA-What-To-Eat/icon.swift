//
//  icon.swift
//  anitest
//
//  Created by zinsser on 11/7/15.
//  Copyright © 2015 zinsser. All rights reserved.
//

import Foundation
import UIKit

let iconSize = 250

class icon {
    static var displacement:CGFloat = 125.0
    static var randomPool:[String] = [String]()
    var n = -1 {
        didSet
        {
            self.setImageWithFile(icon.randomPool[n])
        }
    }
    func shuffle() -> Void
    {
        n = Int(arc4random_uniform(UInt32(icon.randomPool.count)))
    }
    func updateTransform() -> Void
    {
        var t = CATransform3DIdentity
        if (y%2 == 0)
        {
            t = CATransform3DTranslate(t, CGFloat(x)*250.0, CGFloat(y)*250.0, 0)
        }
        else
        {
            t = CATransform3DTranslate(t, CGFloat(x)*250.0+icon.displacement, CGFloat(y)*250.0, 0)
        }
        t = CATransform3DTranslate(t, dx, dy, 0)
        t = CATransform3DRotate(t, rotate, 0, 0, 1.0)
        self.layer.transform = t
    }
    var layer:CALayer
    var x:Int = 0 {
        didSet
        {
            if (oldValue != x)
            {
                self.updateTransform()
            }
        }
    }
    var y:Int = 0 {
        didSet
        {
            if (oldValue != y)
            {
                self.updateTransform()
            }
        }
    }
    var dx:CGFloat = 0.0 {
        didSet
        {
            if (oldValue != dx)
            {
                self.updateTransform()
            }
        }
    }
    var dy:CGFloat = 0.0 {
        didSet
        {
            if (oldValue != dy)
            {
                self.updateTransform()
            }
        }
    }
    var rotate:CGFloat = 0.0 {
        didSet
        {
            if (oldValue != rotate)
            {
                self.updateTransform()
            }
        }
    }
    
    init(superframe:CGRect)
    {
        layer = CALayer()
        layer.frame = CGRect(x: 0.5*superframe.width-125, y: 0.5*superframe.height-125, width: 250, height: 250)
        layer.allowsEdgeAntialiasing = true
    }
    
    func setImageWithFile (file:String) -> Void
    {
        let i = UIImage(named: file)
        self.layer.contents =  i?.CGImage
    }
    
    
}