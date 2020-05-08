//
//  TableViewCell.swift
//  newcore
//
//  Created by Dhruv Upadhyay on 29/01/20.
//  Copyright © 2020 Dhruv Upadhyay. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var lblTrack: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
