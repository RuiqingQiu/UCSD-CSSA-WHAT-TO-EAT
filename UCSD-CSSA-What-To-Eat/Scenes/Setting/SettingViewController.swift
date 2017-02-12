//
//  SettingViewController.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Ruiqing Qiu on 2/6/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var Save: UIBarButtonItem!
    
    var preferenceLists = PreferenceListDataProvider.sharedInstance.preferenceListsSync()
    
    //Prevent user from rotating the view
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    var ListNames = ["Dining Hall", "Campus", "Convoy", "My List"];

    let def = UserDefaults.standard
    @IBAction func SaveSettings(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
           }
    
    var bar_color = UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 0.66)
    var entry_color = UIColor(red: 201/256, green: 176/256, blue: 151/256, alpha: 0.66)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingHeader", bundle: nil), forCellReuseIdentifier: "idSettingHeader")
        
        self.tableView.register(UINib(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "idSettingSwitchCell")
        self.tableView.register(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: "idSettingListCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        ListNames = preferenceLists.map( {$0.name} )
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        pickerView.isHidden = true;
        self.view.addSubview(pickerView)
        let tmp = UserDefaults.standard.string(forKey: "musicSelected")
        if(tmp != nil){
            var i = 0
            for p in pickerDataSource{
                if(p == tmp){
                    pickerView.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i += 1
            }
        }

        //NSUserDefaults.standardUserDefaults().setObject(ListNames, forKey: "ListNames")
        
    }
    var pickerDataSource = ["pikachu", "shotgun", "chicken"];
    var musicSelected = "shotgun";
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        musicSelected = pickerDataSource[row]
        UserDefaults.standard.set(musicSelected, forKey: "musicSelected")
        return pickerDataSource[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7;
    }
    
    func stateChanged(_ switchState: UISwitch) {
        print(UserDefaults.standard.bool(forKey: "EnableSound"))
        if switchState.isOn {
            print("The Switch is On")
            UserDefaults.standard.set(true, forKey: "EnableSound")

        } else {
            print("The Switch is Off")
            UserDefaults.standard.set(false, forKey: "EnableSound")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "idSettingHeader", for: indexPath) as! CustomCell
            cell.categoryLabel.text = "SOUND"
            cell.categoryLabel.font  = UIFont(name: "Avenir", size: 18);
            //cell.backgroundColor =  bar_color;
            return cell

        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "idSettingSwitchCell", for: indexPath) as! CustomCell
            cell.itemLabel.text = "Sound Effects"
            cell.EnableSound.isOn = def.bool(forKey: "EnableSound")
            cell.EnableSound.addTarget(self, action: #selector(SettingViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
            cell.EnableSound.isOn = UserDefaults.standard.bool(forKey: "EnableSound")
            //cell.backgroundColor =  bar_color;
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "idSettingHeader", for: indexPath) as! CustomCell
            cell.categoryLabel.text = "CUSTOMIZE LIST NAME"
            cell.categoryLabel.font  = UIFont(name: "Avenir", size: 18);
            //cell.backgroundColor =  bar_color;
            return cell


        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "idSettingListCell", for: indexPath) as! CustomCell
            let tmp = indexPath.row - 2;
            cell.itemLabel.text = ListNames[tmp-1];
            return cell

        }
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print(ListNames);
        print(String(indexPath.row) + " is clicked");
        let cell = tableView.dequeueReusableCell(withIdentifier: "idSettingListCell", for: indexPath) as! CustomCell
        if(indexPath.row == 0){
            pickerView.isHidden = !pickerView.isHidden;
            if(pickerView.isHidden == true){
            }
        }
        if(indexPath.row >= 3 && indexPath.row <= 6){
            let lname = ListNames[indexPath.row - 3]
            let alert = UIAlertController(title: "Change List Name", message: "New Name for " + lname, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
            //Create action button for empty string alert
            let cancelAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler:nil)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                if ((alert.textFields![0].text!.isEmpty)){
                    let alert1 = UIAlertController(title: "List Name Empty", message: "List Name can not be empty", preferredStyle: UIAlertControllerStyle.alert)
                    alert1.addAction(cancelAction)
                    self.present(alert1, animated: true, completion: nil)
                }
                else{
                    self.ListNames[indexPath.row - 3] = alert.textFields![0].text!
                    UserDefaults.standard.set(self.ListNames, forKey: "ListNames")
                    cell.itemLabel.text = alert.textFields![0].text!
                    cell.reloadInputViews()
                    tableView.reloadData();
                }
            }))
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter List Name"
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        
        UserDefaults.standard.set(ListNames, forKey: "ListNames")
        
           }

}
