//
//  PreferenceListDataProvider.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 1/22/17.
//  Copyright © 2017 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse
import CocoaLumberjack

class PreferenceListDataProvider: NSObject {
    
    static let sharedInstance = PreferenceListDataProvider()
    
    private var preferenceLists = [PreferenceList]()
    // MARK: - Lifecycle

    private override init() {
        super.init()
    }
    
    // MARK: - Public Interface
    
    func preferenceLists(callback: @escaping (([PreferenceList]) -> Void)) {

        if preferenceLists.count > 0 {
            callback(preferenceLists)
            return
        }
        
        guard let query = PreferenceList.query() else { return }
        query.fromLocalDatastore()
        query.addAscendingOrder("index")
        query.findObjectsInBackground { (objects, error) in
            guard error == nil else {
                DDLogError("PreferenceListDataProvider: \(error)")
                return
            }
            guard let preferenceLists = objects as? [PreferenceList] else {
                DDLogError("PreferenceListDataProvider: cannot convert to PreferenceList Array")
                return
            }
            
            self.preferenceLists = preferenceLists
            callback(preferenceLists)
        }
    }
    
    func preferenceListsSync() -> [PreferenceList] {
        if preferenceLists.count > 0 {
            return preferenceLists
        }
        
        let query = PreferenceList.query()
        query?.fromLocalDatastore()
        query?.addAscendingOrder("index")
        preferenceLists = (try? query?.findObjects()) as? [PreferenceList] ?? [PreferenceList]()
        
        return preferenceLists
    }
    
    func initPreferenceList(callback: ((Bool)->Void)?) {
        RestaurantDataProvider.sharedInstance.restaurants {(restaurants, error) in
            
            self.preferenceLists.append(self.dininghallPreferenceList(restaurants: restaurants!))
            self.preferenceLists.append(self.campusPreferenceList(restaurants: restaurants!))
            self.preferenceLists.append(self.convoyPreferenceList(restaurants: restaurants!))
            self.preferenceLists.append(self.emptyPreferenceList(restaurants: restaurants!))
            PreferenceList.pinAll(inBackground: self.preferenceLists) { (success, error) in
                callback?(success)
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func dininghallPreferenceList(restaurants: [Restaurant]) -> PreferenceList {
        let list = PreferenceList()
        list.objectId = "Dining Hall"
        list.name = "Dining Hall"
        list.index = 0.0
        list.restaurants.append(contentsOf: restaurants.filter { $0.style == "Dining Hall"})
        return list
    }

    private func campusPreferenceList(restaurants: [Restaurant]) -> PreferenceList {
        let list = PreferenceList()
        list.objectId = "Campus"
        list.name = "Campus"
        list.index = 1.0
        list.restaurants.append(contentsOf: restaurants.filter { $0.location == "Campus" && ($0.style == "Restaurant" || $0.style == "Dining Hall")})
        return list
    }
    
    private func convoyPreferenceList(restaurants: [Restaurant]) -> PreferenceList {
        let list = PreferenceList()
        list.objectId = "Convoy"
        list.name = "Convoy"
        list.index = 2.0
        list.restaurants.append(contentsOf: restaurants.filter { $0.location == "Convoy"})
        return list
    }
    
    private func emptyPreferenceList(restaurants: [Restaurant]) -> PreferenceList {
        let list = PreferenceList()
        list.objectId = "Campus All"
        list.name = "Campus All"
        list.index = 3.0
        list.restaurants.append(contentsOf: restaurants.filter { $0.location == "Campus"})
        return list
    }
}
