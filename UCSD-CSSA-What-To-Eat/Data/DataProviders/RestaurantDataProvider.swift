//
//  RestaurantDataProvider.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 2/5/17.
//  Copyright © 2017 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse
import CocoaLumberjack
import ReachabilitySwift

class RestaurantDataProvider: NSObject {
    
    static let sharedInstance = RestaurantDataProvider()
    
    private var restaurants = [Restaurant]()
    
    // MARK: - Lifecycle
    
    private override init() { super.init() }
    
    // MARK: - Public Interafce
    func loadFromParse(lastUpdateDate: NSDate? = nil, callback: ((Bool)->Void)?) {
        
        var query = Restaurant.query()
        
        if let lastUpdateDate = lastUpdateDate {
            let createDateQuery = Restaurant.query()!
            createDateQuery.whereKey("createdAt", greaterThanOrEqualTo: lastUpdateDate)
            let updateDateQuery = Restaurant.query()!
            updateDateQuery.whereKey("updatedAt", greaterThanOrEqualTo: lastUpdateDate)
            query = PFQuery.orQuery(withSubqueries: [createDateQuery, updateDateQuery])
        } else {
            try? Restaurant.unpinAllObjects()
        }
        
        query?.includeKey("categories")
        query?.findObjectsInBackground { restaurants, error in
            guard error == nil else {
                DDLogError("RestaurantDataProvider: Error downloading \(error)")
                callback?(false)
                return
            }
            
            guard let restaurants = restaurants as? [Restaurant] else {
                DDLogError("RestaurantDataProvider: Error Converting Restaurants ")
                callback?(false)
                return
            }
            
            Restaurant.pinAll(inBackground: restaurants, block: { (success, error) in
                callback?(success)
            })
        }
    }
    
    
    func loadRestaurantsFromPlist() -> [Restaurant]? {
        
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        let plistPath: String? = Bundle.main.path(forResource: "Restaurants", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
            
        guard let plistData = (try? PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat)) as? [[String:AnyObject]] else {
            DDLogError("RestaurantDataProvider: Error reading Restaurants.plist")
            return nil
        }
        
        var restaurants = [Restaurant]()
        for restaurantData in plistData {
            
            let restaurant = Restaurant()
            restaurant.objectId = restaurantData["_id"] as? String
            restaurant.name = restaurantData["name"] as! String
            restaurant.address = restaurantData["address"] as! String
            restaurant.nickname = restaurantData["nickname"] as! String
            restaurant.yelp = restaurantData["yelp"] as! String
            restaurant.phone = restaurantData["phone"] as! String
            restaurant.voucher = restaurantData["voucher"] as! String
            restaurant.is_collaborate = restaurantData["isCollaborate"] as! Int
            restaurant.pngName = restaurantData["pngName"] as! String
            restaurant.loadFromInternet = false
            
            let categoriesData = restaurantData["category"] as! [[String:AnyObject]]
            for categoryData in categoriesData {
                let category = Category()
                category.name = categoryData["name"] as! String
                category.type = categoryData["type"] as! String
                restaurant.categories.append(category)
            }
            
            restaurants.append(restaurant)
        }
        self.restaurants = restaurants
        return restaurants        
    }
    
    func restaurants(callback: @escaping (([Restaurant]?, Error?)->Void)) {
        
        if restaurants.count > 0 {
            callback(restaurants, nil)
            return
        }
        
        let query = Restaurant.query()
        query?.fromLocalDatastore()
        query?.includeKey("categories")
        query?.findObjectsInBackground { (objects, error) in
            guard let restaurants = objects as? [Restaurant], error == nil else {
                DDLogError("RestaurantDataProvider: Unable to read data from local datastore, \(error)")
                callback(nil, error)
                return
            }
            
            if restaurants.count == 0 {
                callback(self.loadRestaurantsFromPlist(), nil)
            }
            self.restaurants = restaurants
            callback(restaurants, nil)
        }
    }
    
}
