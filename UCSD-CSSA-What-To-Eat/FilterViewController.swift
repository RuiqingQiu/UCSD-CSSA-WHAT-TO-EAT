//
//  FilterViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by zinsser on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

class FilterViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
    
    @IBOutlet weak var Save: UIBarButtonItem!
    
    @IBOutlet weak var Settings: UIBarButtonItem!
    @IBOutlet weak var tblExpandable: UITableView!
    
    @IBOutlet weak var defaultList: UIBarButtonItem!
    
    @IBOutlet weak var list2: UIBarButtonItem!
   
    @IBOutlet weak var list3: UIBarButtonItem!
    
    @IBOutlet weak var list4: UIBarButtonItem!
    
    //Prevent user from rotating the view
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    var ListNames = ["List 1", "List 2", "List 3", "List 4"];
    
    @IBAction func defaultListClicked(sender: AnyObject)
    {
        currentListName = "1"
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
    }
    
    @IBAction func list2Clicked(sender: AnyObject)
    {
        currentListName = "2"
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
    }
    
    
    
    @IBAction func list3Clicked(sender: AnyObject)
    {
        currentListName = "3"
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()

    }
    @IBAction func list4Clicked(sender: AnyObject)
    {
        currentListName = "4"
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()

    }
    @IBAction func SaveAction(sender: AnyObject) {
        
        if checkListNil() == true
        {
            let alert = UIAlertController(title: "No restaurant selected", message: "You need to select at least one restaurant!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func SetSettings(sender: AnyObject) {
        let SettingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController")
        
        SettingViewController.modalTransitionStyle
            = UIModalTransitionStyle.CrossDissolve
        
        self.presentViewController(SettingViewController, animated: true, completion: nil)
    }

    func checkListNil() -> Bool
    {
        var b = true
        
        for currentSectionCells in cellDescriptors
        {
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1)
            {
                if ((currentSectionCells as? NSArray)![row] as? NSDictionary)! ["cellIdentifier"] as! String == "idCategoryCell"
                {
                    print(((currentSectionCells as? NSArray)![row] as? NSDictionary)!  ["checked"] as! Int != 0)
                    if((currentSectionCells as? NSArray)![row] as? NSDictionary)!  ["checked"] as! Int != 0
                    {
                        b = false
                    }
                    
                }
            }
            
        }
        return b
    
    }
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.tblExpandable.allowsSelection = true
        self.tblExpandable.delegate = self
        self.tblExpandable.dataSource = self
        //tblExpandable.separatorColor = UIColor.clearColor();
        
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["List 1", "List 2", "List 3", "List 4"];
        }

        defaultList.title = ListNames[0];
        list2.title = ListNames[1];
        list3.title = ListNames[2];
        list4.title = ListNames[3];
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        configureTableView()
        loadCellDescriptors()
        
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["List 1", "List 2", "List 3", "List 4"];
        }
        
        defaultList.title = ListNames[0];
        list2.title = ListNames[1];
        list3.title = ListNames[2];
        list4.title = ListNames[3];

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    // MARK: Custom Functions
    
    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        
        tblExpandable.tableFooterView = UIView(frame: CGRectZero)
        
        
        tblExpandable.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "idCategoryCell")
        
        tblExpandable.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "idItemCell")
        
    }
    
    
    func loadCellDescriptors()
    {
        // getting path to GameData.plist
        //let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileName = "CellDescriptor" +  currentListName + ".plist"
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        let path = fileURL.path!
        //let documentsDirectory = paths[0] as! String
        //let path = documentsDirectory.stringByAppendingPathComponent("CellDescriptor.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle CellDescriptor.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                    print("error")
                }
                //fileManager.copyItemAtPath(bundlePath, toPath: path)
                print("copy")
            } else {
                print("CellDescriptor.plist not found. Please, make sure it is part of the bundle.")
            }
        }
        
        cellDescriptors = NSMutableArray(contentsOfFile: path)
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        
        
    }

    func saveData()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let fileName = "CellDescriptor" +  currentListName + ".plist"
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        cellDescriptors.writeToFile(path, atomically: true)
    }
    

    
    func getIndicesOfVisibleRows()
    {
        visibleRowsPerSection.removeAll()
        
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1)
            {
                if ((currentSectionCells as? NSArray)![row] as? NSDictionary)!["isVisible"] as! Bool == true
                {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
    }
    
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (cellDescriptors[indexPath.section]as? NSArray)![indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }
    
    
    // MARK: UITableView Delegate and Datasource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if cellDescriptors != nil
        {
            return cellDescriptors.count
        }
        else {
            return 0
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return visibleRowsPerSection[section].count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
            case "idItemCell":
                return 36.0
            
            
        default:
            return 44.0
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        var indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCategoryCell"
        {
            if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpandable"] as! Bool == true
            {
                var shouldExpandAndShowSubRows = false
                if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpanded"] as! Bool == false
                {
                    // In this case the cell should expand.
                    shouldExpandAndShowSubRows = true
                }
                
                cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
                
                //((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as!
                for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["additionalRows"] as! Int))
                {
                    cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
                }
            }
            getIndicesOfVisibleRows()
            saveData()
            
            tblExpandable.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)

        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idItemCell"
        {
            let checked  = ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Bool
            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(!checked, forKey: "checked")
            
            //let category = indexOfTappedRow
            var i = 0
            var c = 0
            indexOfTappedRow = 1
            
            while(indexOfTappedRow < cellDescriptors[indexPath.section].count &&
                ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["cellIdentifier"] as! String != "idCategoryCell")
            {
                if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Bool == true
                {
                    i++
                }
                c++
                indexOfTappedRow++
                
            }
            
            if i == 0
            {
                cellDescriptors[indexPath.section][0].setValue(0, forKey: "checked")
            }
            else if i == c
            {
                cellDescriptors[indexPath.section][0].setValue(1, forKey: "checked")
                
            }
            else
            {
                cellDescriptors[indexPath.section][0].setValue(2, forKey: "checked")
                
            }
            getIndicesOfVisibleRows()
            saveData()
            tblExpandable.reloadData()

        }
        


    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! CustomCell
        
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCategoryCell"
        {
            cell.section = indexPath.section
            cell.row = indexPath.row
            cell.categoryDownButton.tag = indexPath.row;
            cell.categoryDownButton.addTarget(self, action: "categoryDownTouchUpInside:", forControlEvents: .TouchUpInside)
            cell.categoryCheckButton.addTarget(self, action: "categoryCheckTouchUpInside:", forControlEvents: .TouchUpInside)
            
            if let label = currentCellDescriptor["label"]
            {
                cell.categoryLabel?.text = label as? String
            }
            
            //(currentSectionCells as? NSArray)![0] as? NSDictionary)!["isVisible"] as! Bool == true
            
            if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Int == 1
            {
                cell.categoryCheckButton.setImage(UIImage(named: "CheckBox_3.png"), forState: .Normal)
            }
            else if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Int == 0
            {
                cell.categoryCheckButton.setImage(UIImage(named: "CheckBox_1.png"), forState: .Normal)
            }
            else
            {
                cell.categoryCheckButton.setImage(UIImage(named: "CheckBox_2.png"), forState: .Normal)
            }
            
            
            if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpanded"] as! Bool == true
            {
                cell.categoryDownButton.setImage(UIImage(named: "DropDownArrow.png"), forState: .Normal)
            }
            else
            {
                cell.categoryDownButton.setImage(UIImage(named: "RightArrow.png"), forState: .Normal)
            }

            
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idItemCell"
        {
            cell.section = indexPath.section
            cell.row = indexPath.row
            //cell.item.tag = indexPath.row;
            cell.itemCheckButton.addTarget(self, action: "itemCheckTouchUpInside:", forControlEvents: .TouchUpInside)
            
            if let label = currentCellDescriptor["label"]
            {
                cell.itemLabel?.text = label as? String
            }
            // ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as!
            if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Bool == true
            {
                cell.itemCheckButton.setImage(UIImage(named: "RadioButton_2.png"), forState: .Normal)
            }
            else
            {
                cell.itemCheckButton.setImage(UIImage(named: "RadioButton_1.png"), forState: .Normal)
            }
            
        }
        cell.delegate = self
        saveData()
        
        return cell
    }
    
    @IBAction func categoryDownTouchUpInside(sender: UIButton)
    {
        
        let pointInTable = sender.convertPoint(sender.bounds.origin, toView: self.tblExpandable)
        let indexPath = self.tblExpandable.indexPathForRowAtPoint(pointInTable)
        
        let indexOfTappedRow = visibleRowsPerSection[indexPath!.section][indexPath!.row]
        
        
        //((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as!
        if ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpandable"] as! Bool == true
        {
            var shouldExpandAndShowSubRows = false
            if ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpanded"] as! Bool == false
            {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            cellDescriptors[indexPath!.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            //((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as!
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["additionalRows"] as! Int))
            {
                cellDescriptors[indexPath!.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        getIndicesOfVisibleRows()
        saveData()
        tblExpandable.reloadSections(NSIndexSet(index: indexPath!.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    @IBAction func categoryCheckTouchUpInside(sender: UIButton)
    {
        let pointInTable = sender.convertPoint(sender.bounds.origin, toView: self.tblExpandable)
        let indexPath = self.tblExpandable.indexPathForRowAtPoint(pointInTable)
        var indexOfTappedRow = visibleRowsPerSection[indexPath!.section][indexPath!.row]
        
        var checked = ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Int
        if checked == 0
        {
            checked = 1
        }
        else if checked == 1
        {
            checked = 0
        }
        else if checked == 2
        {
            checked = 1
        }
        
        
        cellDescriptors[indexPath!.section][indexOfTappedRow].setValue(checked, forKey: "checked")
        
        while(indexOfTappedRow++ < cellDescriptors[indexPath!.section].count - 1)
        {
            cellDescriptors[indexPath!.section][indexOfTappedRow].setValue(checked, forKey: "checked")
        }
        
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        saveData()
        
    }
    
    
    @IBAction func itemCheckTouchUpInside(sender: UIButton)
    {
        let pointInTable = sender.convertPoint(sender.bounds.origin, toView: self.tblExpandable)
        let indexPath = self.tblExpandable.indexPathForRowAtPoint(pointInTable)
        var indexOfTappedRow = visibleRowsPerSection[indexPath!.section][indexPath!.row]
    
        
        let checked  = ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Bool
        cellDescriptors[indexPath!.section][indexOfTappedRow].setValue(!checked, forKey: "checked")
        
        //let category = indexOfTappedRow
        var i = 0
        var c = 0
        indexOfTappedRow = 1
        
        while(indexOfTappedRow < cellDescriptors[indexPath!.section].count &&
            ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["cellIdentifier"] as! String != "idCategoryCell")
        {
            if ((cellDescriptors[indexPath!.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Bool == true
            {
                i++
            }
            c++
            indexOfTappedRow++
            
        }
        
        if i == 0
        {
            cellDescriptors[indexPath!.section][0].setValue(0, forKey: "checked")
        }
        else if i == c
        {
            cellDescriptors[indexPath!.section][0].setValue(1, forKey: "checked")
            
        }
        else
        {
            cellDescriptors[indexPath!.section][0].setValue(2, forKey: "checked")
            
        }
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        saveData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
