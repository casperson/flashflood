//
//  PostCell.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/24/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var repliesCountLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
}

