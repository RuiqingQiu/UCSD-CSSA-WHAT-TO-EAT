//
//  Restaurant.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by MI YUJIAN on 11/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import Parse
import UIKit

class Restaurant : PFObject, PFSubclassing {
    
    @NSManaged var name : String
    @NSManaged var nickname : String
    @NSManaged var yelp : String
    @NSManaged var address : String
    @NSManaged var is_collaborate : Int
    @NSManaged var image : PFFile
    @NSManaged var Category : PFRelation<Category>
    @NSManaged var phone : String
    @NSManaged var voucher : String
    @NSManaged var imageUpdateTime : NSDate
    @NSManaged var categories: [Category]
    @NSManaged var pngName: String
    
    var localImage : UIImage!

    var loadFromInternet = true // set to false when load from plist

    var location: String {
        for category in categories {
            if category.categoryType == .Location {
                return category.name
            }
        }
        return ""
    }
    
    var style: String {
        for category in categories {
            if category.categoryType == .Style {
                return category.name
            }
        }
        return "Other"
    }
    
    static func parseClassName() -> String {
        return "Restaurant"
    }
    
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
//    
//    func loadLocalImage(url: URL) {
//        print("Download Started")
//        getDataFromUrl(url: url) { (data, response, error)  in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() { () -> Void in
//                self.localImage = UIImage(data: data)!
//                let fileManager = FileManager.default
//                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.name)
//                let image = self.localImage
//                let imageData = UIImageJPEGRepresentation(image!, 0.5)
//                fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//                let test = UIImage(contentsOfFile: paths)
//                print("!!!!!!!!!!")
//                print(test)
//            }
//        }
//    }
//    
//    func saveImage (){
//        let escapedString = image.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        loadLocalImage(url: NSURL(string : escapedString!) as! URL)
//    }
    
//    func getImage () {
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.name);
//        let image = UIImage(contentsOfFile: paths)
//        print("!!!!!!!!!!")
//        print(image)
//        paths	String	"/Users/xinghangli/Library/Developer/CoreSimulator/Devices/04DDCB0A-A5F0-4FCF-BCFF-614116067651/data/Containers/Data/Application/98DD31A4-F322-44CB-9C17-1A4C8AA0765D/Documents/Chef Chin Restaurant"
//    }
    
}
