//
//  FilterViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by zinsser on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

struct SectionItem {

    var checked: Int
    var isExpanded: Bool
    let label: String
    let png: String
    let utf8Name: String
    let cellIdentifier: String

    init(data: [String: AnyObject]) {
        checked = (data["checked"] as? Int) ?? 0
        isExpanded = (data["isExpanded"] as? Bool) ?? false
        label = (data["label"] as? String) ?? ""
        png = (data["png"] as? String) ?? ""
        utf8Name = (data["utf8Name"] as? String) ?? ""
        cellIdentifier = (data["cellIdentifier"] as? String) ?? ""
    }

    func toDict() -> [String: AnyObject] {

        var dict = [String: AnyObject]()
        dict["checked"] = checked as AnyObject?
        dict["isExpanded"] = isExpanded as AnyObject?
        dict["label"] = label as AnyObject?
        dict["png"] = png as AnyObject?
        dict["utf8Name"] = utf8Name as AnyObject?
        dict["cellIdentifier"] = cellIdentifier as AnyObject?
        return dict
    }
}

struct CellDescriptor {

    var checked: Bool
    let label: String
    let png: String
    let utf8Name: String
    let cellIdentifier: String
    
    init(data: [String: AnyObject]) {
        
        checked = (data["checked"] as? Bool) ?? false
        label = (data["label"] as? String) ?? ""
        png = (data["png"] as? String) ?? ""
        utf8Name = (data["utf8Name"] as? String) ?? ""
        cellIdentifier = (data["cellIdentifier"] as? String) ?? ""
    }

    func toDict() -> [String: AnyObject] {

        var dict = [String: AnyObject]()
        dict["checked"] = checked as AnyObject?
        dict["label"] = label as AnyObject?
        dict["png"] = png as AnyObject?
        dict["utf8Name"] = utf8Name as AnyObject?
        dict["cellIdentifier"] = cellIdentifier as AnyObject?
        return dict
    }
}


class FilterViewController:  UIViewController {


    let HEADER_REUSE_IDENTIFIER = "CategoryHeaderView"
    let CELL_REUSE_IDENTIFIER = "RestaurantCell"

    @IBOutlet weak var Save: UIBarButtonItem!
    @IBOutlet weak var Settings: UIBarButtonItem!
    @IBOutlet weak var tblExpandable: UITableView!
    @IBOutlet weak var listButtonContainer: UIStackView!
    @IBOutlet var listbuttons: [ListButton]!

    var currentListName = ""
    var listNames = [String]()
    var cellDescriptors = [[CellDescriptor]]()
    var sectionItems = [SectionItem]()
    var visibleRowsPerSection = [[Int]]()

    var currentListIndex: Int {
        return listNames.index(of: currentListName) ?? 0
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent

        setupTableView()
        setupListNames()
        setupListButtons()
        loadCellDescriptors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    // MARK: - Setup

    func setupListNames() {

        if(UserDefaults.standard.array(forKey: "ListNames") != nil) {
            listNames = UserDefaults.standard.array(forKey: "ListNames")as! [String]
        } else {
            listNames = ["Dining Hall", "Campus", "Convoy", "My List"]
        }
        currentListName = UserDefaults.standard.string(forKey: "currentListName") ?? listNames[0]
    }

    func setupListButtons() {

        for (i, listName) in listNames.enumerated() {

            listbuttons[i].setName(listName)
            listbuttons[i].onPressButton = { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.listbuttons[strongSelf.currentListIndex].highlight(false)
                strongSelf.currentListName = strongSelf.listNames[i]
                strongSelf.listbuttons[i].highlight(true)
                strongSelf.loadCellDescriptors()
                strongSelf.tblExpandable.reloadData()
            }
            if i == currentListIndex {
                listbuttons[i].highlight(true)
            }
        }
    }

    func setupTableView() {

        self.tblExpandable.allowsSelection = true
        self.tblExpandable.delegate = self
        self.tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRect.zero)
        tblExpandable.register(UINib(nibName: "CategoryHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: HEADER_REUSE_IDENTIFIER)
        tblExpandable.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: CELL_REUSE_IDENTIFIER)
    }
    
    //For detect motion start event
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {

        if motion == .motionShake{
            
        }
    }
    
    //For detecting motion end evenet
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
        }
    }

    // MARK: - Private Helpers

    private func loadCellDescriptors() {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "CellDescriptor\(currentListIndex + 1).plist"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let path = fileURL.path
        let fileManager = FileManager.default

        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "CellDescriptor\(currentListIndex + 1)", ofType: "plist") {
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch _ {
                    print("error")
                }
            } else {
                print("CellDescriptor.plist not found. Please, make sure it is part of the bundle.")
            }
        }

        guard let data = NSArray(contentsOfFile: path) else { return }
        cellDescriptors.removeAll()
        sectionItems.removeAll()
        for i in 0 ..< data.count {
            guard let sectionData = data[i] as? [[String: AnyObject]] else { continue }
            cellDescriptors.append([CellDescriptor]())
            for (j,cellDescriptorData) in sectionData.enumerated() {
                if j == 0 {
                    sectionItems.append(SectionItem(data: cellDescriptorData))
                } else {
                    cellDescriptors[i].append(CellDescriptor(data: cellDescriptorData))
                }
            }
        }

        tblExpandable.reloadData()
    }

    private func saveData() {

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let fileName = "CellDescriptor\(currentListIndex+1).plist"
        let path = documentsDirectory.appendingPathComponent(fileName)

        let saveData = NSMutableArray()
        for i in 0 ..< sectionItems.count {
            let array = NSMutableArray()
            array.add(sectionItems[i].toDict())
            for cellDescriptor in cellDescriptors[i] {
                array.add(cellDescriptor.toDict())
            }
            saveData.add(array)
        }
        saveData.write(toFile: path, atomically: true)
    }

    private func checkListNil() -> Bool {
        let count = cellDescriptors.reduce(0, {
            result, cellDescriptorSection in
            return result + cellDescriptorSection.reduce(0, {$0 + ($1.checked ? 1 : 0)})
        })
        return count == 0
    }

    // MARK: - Target and Action

    @IBAction func SaveAction(_ sender: AnyObject) {
        
        if checkListNil() == true {
            let alert = UIAlertController(title: "No restaurant selected", message: "You need to select at least one restaurant!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
            saveData()
        }
    }

    @IBAction func SetSettings(_ sender: AnyObject) {
        let SettingViewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingViewController")
        
        SettingViewController.modalTransitionStyle
            = UIModalTransitionStyle.crossDissolve
        
        self.present(SettingViewController, animated: true, completion: nil)
    }
}
