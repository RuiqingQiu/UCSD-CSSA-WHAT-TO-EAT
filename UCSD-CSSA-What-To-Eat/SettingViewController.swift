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
    
    //Prevent user from rotating the view
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    var ListNames = ["List 1", "List 2", "List 3", "List 4"];
    let def = NSUserDefaults.standardUserDefaults()
    @IBAction func SaveSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
           }
    
    var bar_color = UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 0.66)
    var entry_color = UIColor(red: 201/256, green: 176/256, blue: 151/256, alpha: 0.66)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "SettingHeader", bundle: nil), forCellReuseIdentifier: "idSettingHeader")
        
        self.tableView.registerNib(UINib(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "idSettingSwitchCell")
        self.tableView.registerNib(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: "idSettingListCell")
        
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["List 1", "List 2", "List 3", "List 4"];
        }
        

        //NSUserDefaults.standardUserDefaults().setObject(ListNames, forKey: "ListNames")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7;
    }
    
    func stateChanged(switchState: UISwitch) {
        print(NSUserDefaults.standardUserDefaults().boolForKey("EnableSound"))
        if switchState.on {
            print("The Switch is On")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "EnableSound")

        } else {
            print("The Switch is Off")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "EnableSound")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("idSettingHeader", forIndexPath: indexPath) as! CustomCell
            cell.categoryLabel.text = "SOUND"
            cell.categoryLabel.font  = UIFont(name: "Avenir", size: 18);
            //cell.backgroundColor =  bar_color;
            return cell

        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("idSettingSwitchCell", forIndexPath: indexPath) as! CustomCell
            cell.itemLabel.text = "Sound Effects"
            cell.EnableSound.on = def.boolForKey("EnableSound")
            cell.EnableSound.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.EnableSound.on = NSUserDefaults.standardUserDefaults().boolForKey("EnableSound")
            //cell.backgroundColor =  bar_color;
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("idSettingHeader", forIndexPath: indexPath) as! CustomCell
            cell.categoryLabel.text = "CUSTOMIZE LIST NAME"
            cell.categoryLabel.font  = UIFont(name: "Avenir", size: 18);
            //cell.backgroundColor =  bar_color;
            return cell


        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("idSettingListCell", forIndexPath: indexPath) as! CustomCell
            let tmp = indexPath.row - 2;
            cell.itemLabel.text = ListNames[tmp-1];
            return cell

        }
    }
    
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //print(ListNames);
        print(String(indexPath.row) + " is clicked");
        let cell = tableView.dequeueReusableCellWithIdentifier("idSettingListCell", forIndexPath: indexPath) as! CustomCell
        if(indexPath.row >= 3 && indexPath.row <= 6){
            let lname = ListNames[indexPath.row - 3]
            var alert = UIAlertController(title: "Change List Name", message: "New Name for " + lname, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
            //Create action button for empty string alert
            var cancelAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler:nil)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                if ((alert.textFields![0].text!.isEmpty)){
                    var alert1 = UIAlertController(title: "List Name Empty", message: "List Name can not be empty", preferredStyle: UIAlertControllerStyle.Alert)
                    alert1.addAction(cancelAction)
                    self.presentViewController(alert1, animated: true, completion: nil)
                }
                else{
                    self.ListNames[indexPath.row - 3] = alert.textFields![0].text!
                    NSUserDefaults.standardUserDefaults().setObject(self.ListNames, forKey: "ListNames")
                    cell.itemLabel.text = alert.textFields![0].text!
                    cell.reloadInputViews()
                    tableView.reloadData();
                }
            }))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Enter List Name"
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        NSUserDefaults.standardUserDefaults().setObject(ListNames, forKey: "ListNames")
        
           }

}
