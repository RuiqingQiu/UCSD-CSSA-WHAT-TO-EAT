//
//  ViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.

import UIKit
import GLKit
import AudioToolbox
import SwiftSpinner
import ReachabilitySwift

class ViewController: UIViewController {
    
    let reachability = Reachability()!
    var def = UserDefaults.standard
    var shaked = true
    var cellDescriptors: NSMutableArray!
    var listNames = ["Dining Hall", "Campus", "Convoy", "My List"];
    
    var preferenceLists = [PreferenceList]()
    var currentListIndex = 0
    
    var myAnimation: ShakeAnimation?
    
    @IBOutlet weak var shakeMe: UIImageView!
    @IBOutlet weak var filterButton: UIImageView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var dice: UIImageView!
    @IBOutlet weak var selectedName: UILabel!
    @IBOutlet weak var utf8Name: UILabel!
    
    //Prevent user from rotating the view
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAnimation = ShakeAnimation(superViewController: self, randomPool: [])
        // Do any additional setup after loading the view, typically from a nib.
        
        self.filterButton.isUserInteractionEnabled = true
        if def.object(forKey: "EnableSound") == nil {
           def.set(true, forKey: "EnableSound")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.selectedName.alpha = 0
        self.utf8Name.alpha = 0
        self.shakeMe.alpha = 1
        self.dice.alpha = 1
        myAnimation?.resetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if needCheckUpdate() {
            updateData {
                self.setup()
            }
        } else {
            setup()
        }
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
        }
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
    
    // MARK: - Setup
    
    
    func setup() {
        setupData {
            self.setupUI()
            self.setupAnimation()
        }
    }

    func setupData(completion: (()->Void)?) {
        
        let group = DispatchGroup()
        
        group.enter()
        RestaurantDataProvider.sharedInstance.restaurants { _ in
            group.leave() }
        
        group.enter()
        PreferenceListDataProvider.sharedInstance.preferenceLists { [weak self] preferenceLists in
            self?.preferenceLists = preferenceLists
            self?.listNames = preferenceLists.map({ $0.name })
            self?.currentListIndex = UserDefaultManager.sharedInstance.preferenceListIndex()
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion?()
        }
    }
    
    func setupUI() {
        
        filterName.text = listNames[currentListIndex]
    }
    
    func setupAnimation() {
    
        self.myAnimation?.resetView()
        self.myAnimation?.updatePool(getPngSelected())
    }
    
    func setupDownloadNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    // MARK: - Private Helpers
    
    func getPngSelected() -> [Resinfo] {
        
        var infos = [Resinfo]()
        
        for restaurant in preferenceLists[currentListIndex].restaurants {
            infos.append(Resinfo(png: restaurant.pngName, englishName: restaurant.name, utf8Name: restaurant.nickname))
        }

        return infos
    
    }
    
    private func needCheckUpdate() -> Bool {

        let date = UserDefaultManager.sharedInstance.lastUpdateDate() as? Date
        guard let twoWeeksLater = date?.addingTimeInterval(60*60*24*14) else { return true }
        let compareResult = NSDate().compare(twoWeeksLater)
        return (compareResult != .orderedAscending) || needInit()
    }
    
    private func needInit() -> Bool {
        return !UserDefaultManager.sharedInstance.didInitPreferenceList() || !UserDefaultManager.sharedInstance.didInitRestaurant()
    }
    
    // MARK: Update Data Methods
    
    func updateData( completion: (()->Void)? ) {
        
        if reachability.isReachable {
            
            SwiftSpinner.show("Checking for update...")
            updateRestaurants { _ in
                if !UserDefaultManager.sharedInstance.didInitPreferenceList() {
                    self.updatePreferenceLists { _ in
                        SwiftSpinner.hide()
                        completion?()
                    }
                } else {
                    SwiftSpinner.hide()
                    completion?()
                }
            }
        } else {
            
            if !UserDefaultManager.sharedInstance.didInitRestaurant() {
                
                SwiftSpinner.show("Please connect Internet to download restaurants")
                setupDownloadNotification()
            } else {
                
                if !UserDefaultManager.sharedInstance.didInitPreferenceList() {
                    SwiftSpinner.show("Initializing data...")
                    updatePreferenceLists { _ in
                        SwiftSpinner.hide()
                        completion?()
                    }
                }
            }
        }
    }
    
    func updateRestaurants(completion: ((Bool)->Void)?) {
        
        let date = UserDefaultManager.sharedInstance.lastUpdateDate()
        RestaurantDataProvider.sharedInstance.loadFromParse(lastUpdateDate: date) { success in
            if success {
                UserDefaultManager.sharedInstance.setLastUpdateDate(date: NSDate())
                UserDefaultManager.sharedInstance.setInitRestaurants(value: true)
            }
            completion?(success)
        }
    }
    
    func updatePreferenceLists(completion: ((Bool)->Void)?)  {
        
        PreferenceListDataProvider.sharedInstance.initPreferenceList { success in
            if success {
                UserDefaultManager.sharedInstance.setInitPreferenceList(value: true)
            }
            completion?(success)
        }
    }
    
    @objc private func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.show("Checking for update...")
        }
        if reachability.isReachable {
            updateRestaurants { success in
                reachability.stopNotifier()
                if !UserDefaultManager.sharedInstance.didInitPreferenceList() {
                    self.updatePreferenceLists { _ in SwiftSpinner.hide() }
                } else {
                    SwiftSpinner.hide()
                }
            }
        }
    }
}

