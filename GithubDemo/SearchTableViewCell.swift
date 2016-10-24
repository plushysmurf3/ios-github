//
//  SearchTableViewCell.swift
//  GithubDemo
//
//  Created by Savio Tsui on 10/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoAuthor: UILabel!
    @IBOutlet weak var repoStars: UILabel!
    @IBOutlet weak var repoBranches: UILabel!
    @IBOutlet weak var repoDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
