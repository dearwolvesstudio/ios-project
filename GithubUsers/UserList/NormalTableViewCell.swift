//
//  NormalTableViewCell.swift
//  GithubUsers
//
//  Created by dearwolves on 7/9/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit

class NormalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
