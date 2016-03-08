//
//  CommentCell.swift
//  FlashFlood
//
//  Created by Braden Casperson on 3/2/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentUserLabel: UILabel!
    @IBOutlet weak var commentBubbleView: UIView!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var voteCountLabel: UILabel!
   
}
