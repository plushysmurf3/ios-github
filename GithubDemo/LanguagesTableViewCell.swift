//
//  LanguagesTableViewCell.swift
//  GithubDemo
//
//  Created by Savio Tsui on 10/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class LanguagesTableViewCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
