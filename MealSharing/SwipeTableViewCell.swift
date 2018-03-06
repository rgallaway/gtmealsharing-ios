//
//  SwipeTableViewCell.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 3/6/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit

class SwipeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
