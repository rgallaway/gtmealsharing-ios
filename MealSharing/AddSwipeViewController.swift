//
//  AddSwipeViewController.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 3/22/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import Firebase

class AddSwipeViewController: UITableViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var expirationCell: UITableViewCell!
    @IBOutlet weak var expirationField: UITextField!
    var picker = UIDatePicker()
    
    var typeIndex = 0
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        viewTapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTapRecognizer)
        
        // This code is from https://stackoverflow.com/questions/4824043/uidatepicker-pop-up-after-uibutton-is-pressed
        picker.sizeToFit()
        expirationField.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = nil
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done,
                                         target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        expirationField.inputAccessoryView = toolbar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func handleViewTap() {
        amountTextField.resignFirstResponder()
        expirationField.resignFirstResponder()
    }
    
    @IBAction func showPicker() {
        expirationField.becomeFirstResponder()
    }
    
    @IBAction @objc func dismissPicker() {
        expirationField.text = "\(picker.date)"
        expirationField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1) {
            return 2
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) {
            // selected cell is in the "Type" section
            // acts as "radio buttons" - only one type selected at a time
            if (self.typeIndex != indexPath.row) {
                let oldIndexPath = IndexPath(row: self.typeIndex, section: indexPath.section)
                let newCell = tableView.cellForRow(at: indexPath)
                if (newCell?.accessoryType == UITableViewCellAccessoryType.none) {
                    newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    self.typeIndex = indexPath.row
                }
                let oldCell = tableView.cellForRow(at: oldIndexPath)
                if (oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark) {
                    oldCell?.accessoryType = UITableViewCellAccessoryType.none
                }
            }
        } else if (indexPath.section == 2) {
            // selected cell is in the "Location" section
            // acts as "radio buttons" - only one location selected at a time
            if (self.locationIndex != indexPath.row) {
                let oldIndexPath = IndexPath(row: self.locationIndex, section: indexPath.section)
                let newCell = tableView.cellForRow(at: indexPath)
                if (newCell?.accessoryType == UITableViewCellAccessoryType.none) {
                    newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    self.locationIndex = indexPath.row
                }
                let oldCell = tableView.cellForRow(at: oldIndexPath)
                if (oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark) {
                    oldCell?.accessoryType = UITableViewCellAccessoryType.none
                }
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
