//
//  Swipe.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 3/6/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import Firebase

class Swipe {
    //MARK: Properties
    var is_swipe: Bool
    var cur_num_swipes: Int?
    var end_date: Date
    var price: Double
    var start_date: Date
    var start_num_swipes: Int?
    var location: DocumentReference
    var user: DocumentReference
    
    //MARK: Initialization
    init(is_swipe: Bool, cur_num_swipes: Int?, end_date: Date, price: Double,
         start_date: Date, start_num_swipes: Int?, location: DocumentReference,
         user: DocumentReference) {
        self.is_swipe = is_swipe
        self.cur_num_swipes = cur_num_swipes
        self.end_date = end_date
        self.price = price
        self.start_date = start_date
        self.start_num_swipes = start_num_swipes
        self.location = location
        self.user = user
    }
}
