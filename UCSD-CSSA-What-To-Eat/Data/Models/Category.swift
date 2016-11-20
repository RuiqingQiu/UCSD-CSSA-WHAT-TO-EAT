//
//  Category.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by MI YUJIAN on 11/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse

class Category : PFObject, PFSubclassing {
    @NSManaged var name : String

    static func parseClassName() -> String {
        return "Category"
    }
}


