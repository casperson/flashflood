//
//  ViewPostViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 1/15/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit

class ViewPostViewController : UIViewController, UINavigationControllerDelegate{
    
    // MARK: - Properties
    
    var image: UIImage!
    var userId: String?
    
    @IBOutlet weak var postVoteCount: UILabel!
    @IBOutlet weak var postDownvote: UIButton!
    @IBOutlet weak var postUpvote: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "View Post"
//        
//        let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        let rightButton = UIBarButtonItem(title: "Right Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        
//        self.navigationItem.leftBarButtonItem = leftButton
//        self.navigationItem.rightBarButtonItem = rightButton
        // Do any additional setup after loading the view, typically from a nib.
        userId = String(NSUserDefaults.standardUserDefaults().integerForKey("userId"))
        postImageView.contentMode = .ScaleAspectFit
        postImageView.image = image
        postTitle.text = title
    }
    
    // MARK: - Segues
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return postCellAtIndexPath(indexPath)
    }
    
    func postCellAtIndexPath(indexPath:NSIndexPath) -> CommentCell {
        let cell = commentTableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
//        fillCellData(cell, indexPath: indexPath)
        return cell
    }
    
//    func fillCellData(cell:PostCell, indexPath:NSIndexPath) {
//        let cellData = self.posts[indexPath.row]
//        let commentsCount = (cellData["CommentCount"] != nil) ? cellData["CommentCount"] as? String : "0 Replies"
//        let text = cellData["Text"] as? String
//        let voteCount = (cellData["VoteCount"] != nil) ? cellData["VoteCount"] as? String : "0"
//        let url = NSURL(string: (cellData["ContentURL"] as? String)!)
//        let data = NSData(contentsOfURL: url!)
//        let postImage = UIImage(data: data!)
//        
//        let postedDate = (cellData["DateTimePosted"] as? Int)!/1000
//        let postDate = NSDate(timeIntervalSince1970: NSTimeInterval(postedDate))
//        let currentDate = NSDate()
//        let datecomponents = calendar.components(NSCalendarUnit.Hour, fromDate: postDate, toDate: currentDate, options: [])
//        let timeElapsed = String(datecomponents.hour)
//        
//        cell.titleLabel.text = text
//        cell.timeElapsedLabel.text = timeElapsed + "h"
//        cell.voteCountLabel.text = voteCount
//        cell.repliesCountLabel.text = "\(commentsCount) Replies"
//        cell.postImage.contentMode = .ScaleAspectFit
//        cell.postImage.image = postImage
//    }

    
}
