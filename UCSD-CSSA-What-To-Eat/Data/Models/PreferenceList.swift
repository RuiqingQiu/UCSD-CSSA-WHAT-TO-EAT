//
//  PreferenceList.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by MI YUJIAN on 1/22/17.
//  Copyright © 2017 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse

class PreferenceList : PFObject, PFSubclassing {
    
    @NSManaged var name :String
    @NSManaged var restaurants : PFRelation<Restaurant>
    
    static func parseClassName() -> String {
        return "PreferenceList"
    }
}
