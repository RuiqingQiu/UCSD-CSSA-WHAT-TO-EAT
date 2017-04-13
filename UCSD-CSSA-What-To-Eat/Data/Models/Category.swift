//
//  Category.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by MI YUJIAN on 11/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse

enum CategoryType {
    case Location, Style, None
    
    init(string: String) {
        switch string.lowercased() {
        case "location": self = .Location
        case "style" : self = .Style
        default: self = .None
        }
    }
}

class Category : PFObject, PFSubclassing {
    
    @NSManaged var name : String
    @NSManaged var type : String // this is from parse
    
    var categoryType: CategoryType {
        do {
            return CategoryType(string: type)
        }
        catch {
            return .None
        }
    }

    static func parseClassName() -> String {
        return "Category"
    }
}


