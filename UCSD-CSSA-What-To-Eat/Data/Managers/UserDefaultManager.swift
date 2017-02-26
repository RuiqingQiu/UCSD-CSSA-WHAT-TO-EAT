//
//  UserDefaultManager.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 2/9/17.
//  Copyright © 2017 Ruiqing Qiu. All rights reserved.
//

import Foundation

class UserDefaultManager: NSObject {
    
    static let sharedInstance = UserDefaultManager()
    
    private let DID_INIT_RESTAURANTS_KEY = "DID_INIT_RESTAURANTS"
    private let DID_INIT_CATEGORIES_KEY = "DID_INIT_CATEGORIES"
    private let DID_INIT_PREFERENCE_LIST_KEY = "DID_INIT_PREFERENCE_LIST"
    private let PREFERENCE_LIST_INDEX_KEY = "PREFERENCE_LIST_INDEX"
    private let LAST_UPDATE_DATE_KEY = "LAST_UPDATE_DATE"
    
    // MARK: - Lifecycle

    private override init() { super.init() }
    
    // MARK: - Public Interface
    
    func didInitRestaurant() -> Bool {
        return UserDefaults.standard.bool(forKey: DID_INIT_RESTAURANTS_KEY)
    }
    
    func setInitRestaurants(value: Bool) {
        UserDefaults.standard.set(value, forKey: DID_INIT_RESTAURANTS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func didInitCategories() -> Bool {
        return UserDefaults.standard.bool(forKey: DID_INIT_CATEGORIES_KEY)
    }
    
    func setInitCategories(value: Bool) {
        UserDefaults.standard.set(value, forKey: DID_INIT_CATEGORIES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func didInitPreferenceList() -> Bool {
        return UserDefaults.standard.bool(forKey: DID_INIT_PREFERENCE_LIST_KEY)
    }
    
    func setInitPreferenceList(value: Bool) {
        UserDefaults.standard.set(value, forKey: DID_INIT_PREFERENCE_LIST_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func preferenceListIndex() -> Int {
        return UserDefaults.standard.integer(forKey: PREFERENCE_LIST_INDEX_KEY)
    }
    
    func setPreferenceListIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: PREFERENCE_LIST_INDEX_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func lastUpdateDate() -> NSDate? {
        return UserDefaults.standard.object(forKey: LAST_UPDATE_DATE_KEY) as? NSDate
    }
    
    func setLastUpdateDate(date: NSDate) {
        UserDefaults.standard.set(date, forKey: LAST_UPDATE_DATE_KEY)
        UserDefaults.standard.synchronize()
    }
    
}
