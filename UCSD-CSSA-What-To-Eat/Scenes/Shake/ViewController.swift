//
//  ViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.

import UIKit
import GLKit
import MapKit
import AudioToolbox
import CoreLocation
var currentListName = "1"


class ViewController: UIViewController {
    var def = UserDefaults.standard
    var shaked = true
    var cellDescriptors: NSMutableArray!
    var ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];
    
    var myAnimation: ShakeAnimation?
    
    @IBOutlet weak var shakeMe: UIImageView!
    @IBOutlet weak var filterButton: UIImageView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var dice: UIImageView!
    @IBOutlet weak var selectedName: UILabel!
    @IBOutlet weak var utf8Name: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    
    
    //Prevent user from rotating the view
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        myAnimation = ShakeAnimation(superViewController: self, randomPool: getPngSelected())
        
        print("!!!");
        print(getPngSelected());
        self.filterButton.isUserInteractionEnabled = true
        self.mapButton.isUserInteractionEnabled = true
        
        if(UserDefaults.standard.array(forKey: "ListNames") != nil)
        {
            ListNames = UserDefaults.standard.array(forKey: "ListNames")as! [String]
        }
        else
        {
            ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];

        }
        
        if(UserDefaults.standard.string(forKey: "currentListName") != nil)
        {
            currentListName = UserDefaults.standard.string(forKey: "currentListName")!
            print("HERE")
        }
            
        else
        {
            UserDefaults.standard.setValue("1", forKey: "currentListName")
        }
        

        
        
        if def.object(forKey: "EnableSound") == nil {
           def.set(true, forKey: "EnableSound")
           print("set")
        }
           
        filterName.text = ListNames[Int(currentListName)! - 1];
        //print("viewdidiload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        print(getPngSelected());
        self.myAnimation?.resetView()
        self.selectedName.alpha = 0
        self.utf8Name.alpha = 0
        self.shakeMe.alpha = 1
        self.dice.alpha = 1
        self.myAnimation?.updatePool(getPngSelected())
        if(UserDefaults.standard.array(forKey: "ListNames") != nil)
        {
            ListNames = UserDefaults.standard.array(forKey: "ListNames")as! [String]
        }
        else
        {
            ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];

        }
        
        if(UserDefaults.standard.string(forKey: "currentListName") != nil)
        {
            print("HERE")

            currentListName = UserDefaults.standard.string(forKey: "currentListName")!
        }
            
        else
        {
            UserDefaults.standard.setValue("1", forKey: "currentListName")
        }

    
        
        filterName.text = ListNames[Int(currentListName)! - 1];

    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch: UITouch? = touches.first
        if touch?.view == filterButton{
            let FilterViewController = self.storyboard!.instantiateViewController(withIdentifier: "FilterViewController")
            self.present(FilterViewController, animated: true, completion: nil)
            openMapForPlace()
        }
//        if touch?.view == mapButton{
//            print("???????????????????????")
//        }
        super.touchesEnded(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    //For detect motion start event
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{

        }
    }
    
    //For detecting motion end evenet
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            if(UserDefaults.standard.bool(forKey: "EnableSound") == true){
                let musicSelected  = UserDefaults.standard.string(forKey: "musicSelected")
                if let soundURL = Bundle.main.url(forResource: musicSelected, withExtension: "mp3") {
                    var mySound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
                    // Play
                    AudioServicesPlaySystemSound(mySound);
                }
            }
            myAnimation?.shake()
        }
    }
    
    
    func getPngSelected() -> [Resinfo]
    {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "CellDescriptor" +  currentListName + ".plist"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let path = fileURL.path
        let fileManager = FileManager.default
        //check if file exists
        if(!fileManager.fileExists(atPath: path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "CellDescriptor" + currentListName, ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle CellDescriptor.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
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
 
        var returnArray = [Resinfo]()
        
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
                        //var tmp = (currentSectionCells as! NSArray)[row]
                        
                        var englishName = ((currentSectionCells as! NSArray)[row] as! NSDictionary)["label"]
                        if(englishName != nil){
                        }
                        else{
                            englishName = ""
                        }
                        var utf8Name = ((currentSectionCells as! NSArray)[row] as! NSDictionary)["utf8Name"]
                        if(utf8Name != nil){
                            print ("tmp1 is")
                            //print((currentSectionCells as! NSArray)[row]["a"])
                        }
                        else{
                            utf8Name = ""
                        }
                        let r = Resinfo(png:png, englishName:englishName as! String, utf8Name:utf8Name as! String)
                        
                        print(r.png)
                        
                        
                        returnArray.append(r)
                    }
                }
            }
            
        }

        return returnArray
    
    }
    
    func openMapForPlace() {
        
        let address = "9500 Gilman Dr, La Jolla, CA, USA"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                let coordinates = placemark.location!.coordinate
                let regionDistance:CLLocationDistance = 10000
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "Place Name"
                mapItem.openInMaps(launchOptions: options)
            }
        })
        
    }
       
    
}

