//
//  CustomCourseworkTableViewCell.swift
//  iPadd Planner
//
//  Created by Md Bin Amin on 15/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit

class CustomCourseworkTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCourseName: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblDaysRemaining: UILabel!
    @IBOutlet weak var lblModuleName: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
