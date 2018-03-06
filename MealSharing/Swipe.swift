//
//  Swipe.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 3/6/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit

class Swipe {
    //MARK: Properties
    var cur_num_swipes: Int
    var end_date: NSDate
    var price: Double
    var start_date: NSDate
    var start_num_swipes: Int
    
    //MARK: Initialization
    init(cur_num_swipes: Int, end_date: NSDate, price: Double,
         start_date: NSDate, start_num_swipes: Int) {
        self.cur_num_swipes = cur_num_swipes
        self.end_date = end_date
        self.price = price
        self.start_date = start_date
        self.start_num_swipes = start_num_swipes
    }
}
