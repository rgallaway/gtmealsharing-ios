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
    @IBOutlet weak var numSwipesCell: UITableViewCell!
    @IBOutlet weak var numSwipesField: UITextField!
    
    var picker = UIDatePicker()
    
    var typeIndex = 0
    var locationIndex = 0
    var dateStamp: Date? = nil
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
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
        numSwipesField.resignFirstResponder()
    }
    
    @IBAction func showPicker() {
        expirationField.becomeFirstResponder()
    }
    
    @IBAction @objc func dismissPicker() {
        expirationField.text = "\(picker.date)"
        dateStamp = picker.date
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
        if (section == 0) {
            return 2
        } else if (section == 1) {
            return 3
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
                
                // only show Number of Swipes cell if "Meal Swipe" is selected
                tableView.beginUpdates()
                tableView.endUpdates()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 && typeIndex != 0 {
            return 0.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    // This is going to be terrible and not very robust
    // Will need lots of clean-up for public release
    @IBAction func saveButtonClicked(_ sender: Any) {
        let locationsRef = db.collection("locations")
        let locationCell = tableView.cellForRow(at: IndexPath(row: locationIndex, section: 2))
        let query = locationsRef.whereField("name", isEqualTo: locationCell?.textLabel?.text)
        var locationDoc: DocumentReference?
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting location documents: \(err)")
                locationDoc = nil
            } else {
                print("Found location document")
                locationDoc = querySnapshot!.documents[0].reference
                var ref: DocumentReference? = nil
                ref = self.db.collection("swipes").addDocument(data: [
                    "cur_num_swipes": Int(self.numSwipesField.text!),
                    "start_num_swipes": Int(self.numSwipesField.text!),
                    "price": Double(self.amountTextField.text!)!,
                    "start_date": Date(),
                    "end_date": self.dateStamp!,
                    "is_swipe": self.typeIndex == 0,
                    "location": locationDoc,
                    "user": self.db.collection("users").document((Auth.auth().currentUser?.uid)!)
                ]) { err in
                    if let err = err {
                        print("Error adding swipe to db: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }
        
    }
    
    private func locationReference(forIndex index: Int) -> DocumentReference? {
        let locationsRef = db.collection("locations")
        let locationCell = tableView.cellForRow(at: IndexPath(row: index, section: 2))
        let query = locationsRef.whereField("name", isEqualTo: locationCell?.textLabel?.text)
        var doc: DocumentReference?
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting location documents: \(err)")
                doc = nil
            } else {
                print("Found location document")
                doc = querySnapshot!.documents[0].reference
            }
        }
        return doc
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
