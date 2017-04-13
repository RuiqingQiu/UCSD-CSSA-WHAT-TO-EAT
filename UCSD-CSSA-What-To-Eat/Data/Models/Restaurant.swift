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
    var imagePath : String!

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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func loadLocalImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.localImage = UIImage(data: data)!
                let fileManager = FileManager.default
                self.imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(self.name)
                let image = self.localImage
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                fileManager.createFile(atPath: self.imagePath as String, contents: imageData, attributes: nil)
            }
        }
    }
    
    func saveImage (){
        loadLocalImage(url: NSURL(string:image.url!) as! URL)

    }
    
    func isImagePathValid() -> Bool {
        if((self.imagePath) != nil){ return true }
        else{ return false }
    }
    
    func readImageFromLocalPath() -> UIImage? {
        if(isImagePathValid()){
            let image = UIImage(contentsOfFile: self.imagePath)
            return image!
        }
        return nil
    }
    
    
}
