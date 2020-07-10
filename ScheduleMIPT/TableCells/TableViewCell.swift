//
//  TableViewCell.swift
//  Schedule
//
//  Created by Iakov on 21/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var profLabel : UILabel!
    @IBOutlet weak var placeLabel : UILabel!
    @IBOutlet weak var startTimeLabel : UILabel!
    @IBOutlet weak var endTimeLabel : UILabel!
    @IBOutlet weak var timeBackgroundView : UIView!
    @IBOutlet weak var textBackgroundView : UIView!
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
