//
//  icon.swift
//  anitest
//
//  Created by zinsser on 11/7/15.
//  Copyright © 2015 zinsser. All rights reserved.
//

import Foundation
import UIKit

class icon {
    static var iconSize:CGFloat = 250.0
    static var displacement:CGFloat
    {
        get {
            return 0.5 * icon.iconSize
        }
    }
    static var randomPool:[resinfo] = [resinfo]()
    var res:resinfo {
        get {
            return icon.randomPool[n]
        }
    }
    var n = -1 {
        didSet
        {
            self.setImageWithResInfo(icon.randomPool[n])
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
            t = CATransform3DTranslate(t, CGFloat(x)*icon.iconSize, CGFloat(y)*icon.iconSize, 0)
        }
        else
        {
            t = CATransform3DTranslate(t, CGFloat(x)*icon.iconSize+icon.displacement, CGFloat(y)*icon.iconSize, 0)
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
        layer.frame = CGRect(x: 0.5*superframe.width-0.5*icon.iconSize, y: 0.5*superframe.height-0.5*icon.iconSize, width: icon.iconSize, height: icon.iconSize)
        layer.allowsEdgeAntialiasing = true
    }
    
    func setImageWithFile (file:String) -> Void
    {
        let i = UIImage(named: file)
        self.layer.contents =  i?.CGImage
    }
    
    func setImageWithResInfo (info:resinfo) -> Void
    {
        let i = UIImage(named: info.png)
        self.layer.contents = i?.CGImage
    }
    
    
}