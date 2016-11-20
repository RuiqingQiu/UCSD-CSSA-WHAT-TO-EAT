//
//  Restaurant.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by MI YUJIAN on 11/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse

class Restaurant : PFObject, PFSubclassing {
    
    @NSManaged var name : String
    @NSManaged var nickname : String
    @NSManaged var yelp : String
    @NSManaged var address : String
    @NSManaged var is_collaborate : Int
    @NSManaged var image : PFFile
    @NSManaged var Category : PFRelation<PFObject>
    @NSManaged var phone : String
    @NSManaged var voucher : String
    @NSManaged var imageUpdateTime : NSDate

    static func parseClassName() -> String {
        return "Restaurant"
    }
    
}
