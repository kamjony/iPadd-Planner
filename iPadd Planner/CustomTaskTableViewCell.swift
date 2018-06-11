//
//  CustomTaskTableViewCell.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 11/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit

class CustomTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblDaysRemaining: UILabel!
    @IBOutlet weak var lblPerComplete: UILabel!
    @IBOutlet weak var lblNotes: UITextView!
    @IBOutlet weak var customProgbar: CustomProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

}
