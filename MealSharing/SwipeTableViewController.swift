//
//  SwipeTableViewController.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 3/6/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import Firebase

class SwipeTableViewController: UITableViewController {
    //MARK: Properties
    var swipes = [Swipe]()
    var db: Firestore!
    let formatter = DateFormatter()
    
    @IBOutlet var swipeTableView: UITableView!
    
    override lazy var refreshControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SwipeTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        formatter.dateFormat = "E, MMM d, h:mm a"
        self.swipeTableView.addSubview(self.refreshControl!)
        handleRefresh(self.refreshControl!)

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(swipes.count)")
        return swipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("In cellForRowAtIndexPath")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeTableViewCell", for: indexPath) as? SwipeTableViewCell
            else {
                fatalError("Dequeued cell is not an instance of SwipeTableViewCell")
        }
        let swipe = swipes[indexPath.row]
        let amountString = String(format: "$%.02f", swipe.price)
        if swipe.is_swipe {
            cell.typeLabel.text = "S"
            cell.amountLabel.text = "\(swipe.cur_num_swipes!) swipes @ \(amountString) ea."
        } else {
            cell.typeLabel.text = "D"
            cell.amountLabel.text = "Dining Points: \(amountString)"
        }
        cell.elapsedTimeLabel.text = swipe.start_date.timeAgoSinceNow(useNumericDates: true)
        cell.locationLabel.text = swipe.location
        return cell
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        swipes.removeAll()
        db.collection("swipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let swipeData = document.data()
                    print(swipeData)
                    let swipe = Swipe(is_swipe: swipeData["is_swipe"] as! Bool,
                                      cur_num_swipes: swipeData["cur_num_swipes"] as? Int, end_date: swipeData["end_date"] as! Date,
                                      price: swipeData["price"] as! Double, start_date: swipeData["start_date"] as! Date,
                                      start_num_swipes: swipeData["start_num_swipes"] as? Int, location: swipeData["location"] as! String,
                                      user: swipeData["user"] as! String)
                    self.swipes.append(swipe)
                    print("should have \(self.swipes.count) rows")
                }
                print("actually has \(self.swipes.count) rows")
                self.swipeTableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }

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
        if segue.destination is AddSwipeViewController {
            navigationItem.title = nil
        }
    }
    */

}
