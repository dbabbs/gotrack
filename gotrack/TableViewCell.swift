//
//  TableViewCell.swift
//  gotrack
//
//  Created by Zhanna Voloshina on 12/12/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
