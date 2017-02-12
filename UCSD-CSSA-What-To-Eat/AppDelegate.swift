//
//  AppDelegate.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 10/17/15.
//  Copyright © 2015 Ruiqing Qiu. All rights reserved.
//

import UIKit
import Parse
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "CSSA Parse Server"
            $0.clientKey = ""
            $0.isLocalDatastoreEnabled = true
            $0.server = "https://parse.ucsdcssa.org/parse"
        }
        Parse.initialize(with: configuration)
        setupInitialData()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Setup
    
    func setupInitialData() {
        
        let reachability = Reachability()!
        if reachability.isReachableViaWiFi {
            setupRestaurants { _ in
                self.setupPreferenceLists()
            }
        } else {
            setupDownloadNotification()
            setupPreferenceLists()
        }
        
    }
    
    func setupDownloadNotification() {

        let reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                setupRestaurants { success in
                    reachability.stopNotifier()
                }
            }
        }
    }
    
    // MARK: - PrivateHelper
    
    func setupRestaurants(completion: ((Bool)->Void)?) {
        if !UserDefaultManager.sharedInstance.didInitRestaurant() {
//        if true {
            let date = UserDefaultManager.sharedInstance.lastUpdateDate()
            RestaurantDataProvider.sharedInstance.loadFromParse(lastUpdateDate: date) { success in
                if success {
                    UserDefaultManager.sharedInstance.setLastUpdateDate(date: NSDate())
                    UserDefaultManager.sharedInstance.setInitRestaurants(value: true)
                }
                completion?(success)
            }
        }
    }

    func setupPreferenceLists() {
        if !UserDefaultManager.sharedInstance.didInitPreferenceList() {
            PreferenceListDataProvider.sharedInstance.initPreferenceList { success in
                if success {
                    UserDefaultManager.sharedInstance.setInitPreferenceList(value: true)
                }
            }
        }
    }
    
    
}



