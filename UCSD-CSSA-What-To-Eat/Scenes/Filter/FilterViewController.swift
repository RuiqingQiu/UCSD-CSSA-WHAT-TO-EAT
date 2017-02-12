//
//  FilterViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by zinsser on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

struct SectionItem {

    var state: SelectState
    var isExpanded: Bool
    let label: String
    var cellDescriptors: [CellDescriptor]
}

struct CellDescriptor {

    var checked: Bool
    let label: String
    let png: String
    let utf8Name: String
    let restaurant: Restaurant
}


class FilterViewController:  UIViewController {


    let HEADER_REUSE_IDENTIFIER = "CategoryHeaderView"
    let CELL_REUSE_IDENTIFIER = "RestaurantCell"

    @IBOutlet weak var Save: UIBarButtonItem!
    @IBOutlet weak var Settings: UIBarButtonItem!
    @IBOutlet weak var tblExpandable: UITableView!
    @IBOutlet weak var listButtonContainer: UIStackView!
    @IBOutlet var listbuttons: [ListButton]!

    var currentListIndex = UserDefaultManager.sharedInstance.preferenceListIndex()
    var preferenceLists: [PreferenceList]!
    var listNames = [String]()
    var sectionItems = [SectionItem]()
    var restaurantDataProvider = RestaurantDataProvider.sharedInstance

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent

        setupPreferenceLists()
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
    
    func setupPreferenceLists() {
        preferenceLists = PreferenceListDataProvider.sharedInstance.preferenceListsSync()
    }

    func setupListNames() {

        listNames.append(contentsOf: preferenceLists.map({ $0.name }))
    }

    func setupListButtons() {

        for (i, listName) in listNames.enumerated() {

            listbuttons[i].setName(listName)
            listbuttons[i].onPressButton = { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.listbuttons[strongSelf.currentListIndex].highlight(false)
                strongSelf.currentListIndex = i
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
        
        restaurantDataProvider.restaurants { [weak self] (restaurants, error) in
            guard let restaurants = restaurants, error == nil else {
                //TODO: Show Some Error Message Here
                return
            }
            
            guard let strongSelf = self else { return }
            strongSelf.sectionItems = strongSelf.createSectionItemsAndCellDescriptors(restaurants: restaurants)
            strongSelf.tblExpandable.reloadData()
        }
        
    }
    
    private func createSectionItemsAndCellDescriptors(restaurants: [Restaurant]) -> [SectionItem] {
        var sectionItems = [SectionItem]()
        var dict = [String: [Restaurant]]()
        for restaurant in restaurants {
            let sectionTitle = restaurant.location + " - " + restaurant.style
            if !(dict.keys.contains(sectionTitle)) {
                dict[sectionTitle] = [Restaurant]()
            }
            dict[sectionTitle]?.append(restaurant)
        }
        
        let selectedRestaurants = preferenceLists[currentListIndex].restaurants
        
        for (sectionTitle, restaurants) in dict {
            var sectionItem = SectionItem(state: .None, isExpanded: false, label: sectionTitle, cellDescriptors: [CellDescriptor]())
            for restaurant in restaurants {
                let checked = selectedRestaurants.contains(where: { $0.objectId == restaurant.objectId })
                let cellDescriptor = CellDescriptor(checked: checked, label: restaurant.name, png: restaurant.pngName, utf8Name: restaurant.nickname, restaurant: restaurant)
                sectionItem.cellDescriptors.append(cellDescriptor)
            }
            sectionItem.state = computeSelectStateForSectionItem(sectionItem: sectionItem)
            sectionItem.cellDescriptors.sort { $0.0.label < $0.1.label }
            sectionItems.append(sectionItem)
        }
        sectionItems.sort { $0.0.label < $0.1.label }
        return sectionItems
    }
    
    func computeSelectStateForSectionItem(sectionItem: SectionItem) -> SelectState {
        let checkedSum = sectionItem.cellDescriptors.reduce(0, { $0.0 + ($0.1.checked ? 1 : 0)})
        if checkedSum == 0 {
            return .None
        } else if checkedSum == sectionItem.cellDescriptors.count {
            return .Full
        } else {
            return .Half
        }
    }

    private func saveData(restaurants: [Restaurant]) {
        preferenceLists[currentListIndex].restaurants.removeAll()
        preferenceLists[currentListIndex].restaurants.append(contentsOf: restaurants)
        preferenceLists[currentListIndex].pinInBackground()
    }
    
    private func selectedRestaurants() -> [Restaurant] {
        var restaurants = [Restaurant]()
        for sectionItem in sectionItems {
            for cellDescriptor in sectionItem.cellDescriptors {
                if cellDescriptor.checked {
                    restaurants.append(cellDescriptor.restaurant)
                }
            }
        }
        return restaurants
    }

    // MARK: - Target and Action

    @IBAction func SaveAction(_ sender: AnyObject) {
        
        let selected = selectedRestaurants()
        if selected.count == 0 {
            let alert = UIAlertController(title: "No restaurant selected", message: "You need to select at least one restaurant!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            saveData(restaurants: selected)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func SetSettings(_ sender: AnyObject) {
        let SettingViewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingViewController")
        
        SettingViewController.modalTransitionStyle
            = UIModalTransitionStyle.crossDissolve
        
        self.present(SettingViewController, animated: true, completion: nil)
    }
}
