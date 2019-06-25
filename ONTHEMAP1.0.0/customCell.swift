//
//  customCell.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 17/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {
    @IBOutlet  var studentName: UILabel!
    @IBOutlet  var link: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
