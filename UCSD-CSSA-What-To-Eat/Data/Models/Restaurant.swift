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
    @NSManaged var Category : PFRelation<PFObject>
    @NSManaged var phone : String
    @NSManaged var voucher : String
    @NSManaged var imageUpdateTime : NSDate
    
    var localImage : UIImage!

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
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.localImage = UIImage(data: data)!
            }
        }
    }
    
    func saveImageDocumentDirectory(localImage : UIImage, name : String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let image = localImage
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func saveImage (){
        loadLocalImage(url: NSURL(string : image.url!) as! URL)
        saveImageDocumentDirectory(localImage: localImage, name: name)
    }
    
}
