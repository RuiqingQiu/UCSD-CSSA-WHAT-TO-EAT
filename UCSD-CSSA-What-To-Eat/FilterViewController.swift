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
    
    var ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];

    
    @IBAction func defaultListClicked(sender: AnyObject)
    {
        currentListName = "1"
        NSUserDefaults.standardUserDefaults().setValue(currentListName, forKey: "currentListName")
        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        reselectList()
    }
    
    @IBAction func list2Clicked(sender: AnyObject)
    {
        currentListName = "2"
        NSUserDefaults.standardUserDefaults().setValue(currentListName, forKey: "currentListName")

        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        reselectList()
    }
    
    //For detect motion start event
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake{
            
        }
    }
    
    //For detecting motion end evenet
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if motion == .MotionShake {
            
        }
    }
    
    @IBAction func list3Clicked(sender: AnyObject)
    {
        currentListName = "3"
        NSUserDefaults.standardUserDefaults().setValue(currentListName, forKey: "currentListName")

        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        reselectList()

    }
    @IBAction func list4Clicked(sender: AnyObject)
    {
        currentListName = "4"
        NSUserDefaults.standardUserDefaults().setValue(currentListName, forKey: "currentListName")

        configureTableView()
        loadCellDescriptors()
        getIndicesOfVisibleRows()
        tblExpandable.reloadData()
        reselectList()
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
        
        currentListName = NSUserDefaults.standardUserDefaults().stringForKey("currentListName")!
        
        if(NSUserDefaults.standardUserDefaults().arrayForKey("ListNames") != nil)
        {
            ListNames = NSUserDefaults.standardUserDefaults().arrayForKey("ListNames")as! [String]
        }
        else
        {
            ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];
        }
        let width = self.view.frame.width * 0.2
        
        renderBarButton(defaultList, width: width, name: ListNames[0])
        renderBarButton(list2, width: width, name: ListNames[1])
        renderBarButton(list3, width: width, name: ListNames[2])
        renderBarButton(list4, width: width, name: ListNames[3])
        defaultList.customView?.userInteractionEnabled = true
        list2.customView?.userInteractionEnabled = true
        list3.customView?.userInteractionEnabled = true
        list4.customView?.userInteractionEnabled = true
        defaultList.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("defaultListClicked:")))
        list2.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("list2Clicked:")))
        list3.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("list3Clicked:")))
        list4.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("list4Clicked:")))
        reselectList()
    }
    let lcolor = UIColor(red: 242.0/255.0, green: 160.0/255.0, blue: 47.0/255.0, alpha: 1)
    
    func renderBarButton (b: UIBarButtonItem, width: CGFloat, name: String) -> Void
    {
        b.customView = UILabel(frame: CGRectMake(0, 0, width, 28))
        (b.customView as! UILabel).text = name
        (b.customView as! UILabel).textAlignment = NSTextAlignment.Center
        (b.customView as! UILabel).font = UIFont(name: "Helvetica", size: 13)
        (b.customView as! UILabel).layer.borderWidth = 1
        (b.customView as! UILabel).layer.borderColor = lcolor.CGColor
        (b.customView as! UILabel).layer.cornerRadius = 10
        (b.customView as! UILabel).layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
        (b.customView as! UILabel).textColor = lcolor
    }
    
    func changeBarButtonName (b: UIBarButtonItem, name: String) -> Void
    {
        (b.customView as! UILabel).text = name
    }
    
    func selectList (b: UIBarButtonItem) -> Void
    {
        (b.customView as! UILabel).layer.cornerRadius = 10
        (b.customView as! UILabel).layer.backgroundColor = lcolor.CGColor
        (b.customView as! UILabel).textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func deselectList (b: UIBarButtonItem) -> Void
    {
        (b.customView as! UILabel).layer.cornerRadius = 10
        (b.customView as! UILabel).layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
        (b.customView as! UILabel).textColor = lcolor
    }
    
    func reselectList () -> Void
    {
        deselectList(defaultList)
        deselectList(list2)
        deselectList(list3)
        deselectList(list4)
        switch (currentListName)
        {
            case "1":
                selectList(defaultList)
            case "2":
                selectList(list2)
            case "3":
                selectList(list3)
            case "4":
                selectList(list4)
            default: break
        }
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
            ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];
        }
        
        changeBarButtonName(defaultList, name: ListNames[0])
        changeBarButtonName(list2, name: ListNames[1])
        changeBarButtonName(list3, name: ListNames[2])
        changeBarButtonName(list4, name: ListNames[3])
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
            if let bundlePath = NSBundle.mainBundle().pathForResource("CellDescriptor" + currentListName, ofType: "plist") {
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
                cell.categoryCheckButton.setImage(UIImage(named: "LCheckBox_3.png"), forState: .Normal)
            }
            else if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["checked"] as! Int == 0
            {
                cell.categoryCheckButton.setImage(UIImage(named: "LCheckBox_1.png"), forState: .Normal)
            }
            else
            {
                cell.categoryCheckButton.setImage(UIImage(named: "LCheckBox_2.png"), forState: .Normal)
            }
            
            
            if ((cellDescriptors[indexPath.section]as? NSArray)![indexOfTappedRow]as? NSDictionary)!["isExpanded"] as! Bool == true
            {
                cell.categoryDownButton.setImage(UIImage(named: "DownArrow.png"), forState: .Normal)
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
                cell.itemCheckButton.setImage(UIImage(named: "SCheckBox_2.png"), forState: .Normal)
            }
            else
            {
                cell.itemCheckButton.setImage(UIImage(named: "SCheckBox_1.png"), forState: .Normal)
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
