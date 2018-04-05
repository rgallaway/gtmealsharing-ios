//
//  DetailsTableViewController.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 4/2/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DetailsTableViewController: UITableViewController {
    var swipeId: String?
    var isSwipe: Bool?
    var db: Firestore?
    var sellerId: String?
    var userReference: [String : Any?]?
    
    let formatter = DateFormatter()

    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var numSwipesCell: UITableViewCell!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var startTimeCell: UITableViewCell!
    @IBOutlet weak var endTimeCell: UITableViewCell!
    @IBOutlet weak var sellerNameCell: UITableViewCell!
    @IBOutlet weak var sellerEmailCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        formatter.dateFormat = "E, MMM d, h:mm a"
        
        if let id = swipeId {
            print("Got id \(id)")
            // pull swipe data down from database
            let docRef = db?.collection("swipes").document(id)
            docRef?.getDocument() { (snapshot, err) in
                if let err = err {
                    print("failed to get document for id \(id)")
                    print(err)
                } else {
                    let documentData = snapshot!.data()
                    self.isSwipe = documentData!["is_swipe"] as? Bool
                    if (self.isSwipe!) {
                        self.typeCell.detailTextLabel?.text = "Meal Swipe"
                        self.numSwipesCell.detailTextLabel?.text = "\(documentData!["cur_num_swipes"] as! Int)"
                    } else {
                        self.typeCell.detailTextLabel?.text = "Dining Points"
                        self.priceCell.textLabel?.text = "Amount"
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                    self.priceCell.detailTextLabel?.text = "\(documentData!["price"] as! Double)"
                    self.locationCell.detailTextLabel?.text = documentData!["location"] as? String
                    self.startTimeCell.detailTextLabel?.text = self.formatter.string(from: (documentData!["start_date"] as! Date))
                    self.endTimeCell.detailTextLabel?.text = self.formatter.string(from: (documentData!["end_date"] as! Date))
                    self.sellerId = documentData!["user"] as? String
                    
                    // get user info
                    let userRef = self.db?.collection("users").document(self.sellerId!)
                    userRef?.getDocument() { (userSnapshot, userErr) in
                        if let err = userErr {
                            print("failed to get user info for id \(self.sellerId!)")
                            print(err)
                        } else {
                            self.userReference = userSnapshot!.data()
                            if let name = self.userReference!["name"] {
                                self.sellerNameCell.detailTextLabel?.text = name as? String
                            } else {
                                self.sellerNameCell.detailTextLabel?.text = (self.userReference!["firstname"] as! String) + " " + (self.userReference!["lastname"] as! String)
                            }
                            self.sellerEmailCell.detailTextLabel?.text = self.userReference!["email"] as? String
                        }
                    }
                }
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if section == 0 {
            return 6
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let swipe = self.isSwipe {
            if (indexPath.section == 0 && indexPath.row == 1 && !swipe) {
                return 0.0
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
