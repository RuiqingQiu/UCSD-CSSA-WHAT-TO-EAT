//
//  PreferenceListDataProvider.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 1/22/17.
//  Copyright © 2017 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse

class PreferenceListDataProvider: NSObject {
    
    static let sharedInstance = PreferenceListDataProvider()
    
    let DEFAULT_INIT_LIST = "is_init_list"
    
    // MARK: - Lifecycle

    private override init() {
        super.init()
    }
    
    // MARK: - Public Interface
    
    func preferenceLists(callback: ([PreferenceList])->Void) {
        let isListInited = UserDefaults.standard.bool(forKey: DEFAULT_INIT_LIST)
        if isListInited {
            return initialPreferenceList()
        } else {
            
        }
    }
    
    // MARK: - Private Helpers
    
    private func initialPreferenceList() -> [PreferenceList] {
        
    }
}
