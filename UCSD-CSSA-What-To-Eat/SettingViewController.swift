//
//  SettingViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var Save: UIBarButtonItem!
    
    @IBAction func SaveSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
           }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        if(indexPath.row == 0){
            cell.textLabel!.text = "SOUND"
            cell.textLabel!.font  = UIFont(name: "Avenir", size: 18);
            cell.backgroundColor =  UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 0.66);

        }
        else if(indexPath.row == 1){
            cell.textLabel!.text = "Sound Effects"
            cell.backgroundColor =  UIColor(red: 201/256, green: 176/256, blue: 151/256, alpha: 0.66);

        }
        else if(indexPath.row == 2){
            cell.textLabel!.text = "CUSTOMIZE LIST NAME"
            cell.textLabel!.font  = UIFont(name: "Avenir", size: 18);
            cell.backgroundColor =  UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 0.66);

        }
        else{
            let tmp = indexPath.row - 2;
            cell.textLabel!.text = "List " + String(tmp)
            cell.detailTextLabel!.text = "List " + String(tmp)
            cell.backgroundColor =  UIColor(red: 201/256, green: 176/256, blue: 151/256, alpha: 0.66);
        }
        return cell
    }

}
