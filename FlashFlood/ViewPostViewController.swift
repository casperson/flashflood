//
//  ViewPostViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 1/15/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewPostViewController : UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
//    var image: UIImage!
    let userId = String(NSUserDefaults.standardUserDefaults().integerForKey("userId"))
    var postId: String!
    var comments: [JSON]!
    var post: JSON!
    var loaderConfig:SwiftLoader.Config = SwiftLoader.Config()
    
    @IBOutlet var postTable: UITableView!
    
    @IBAction func flagPost(sender: UIButton) {
        let flagViewController = UITableViewController()
        flagViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        presentViewController(flagViewController, animated: true, completion: nil)
        
        let popoverPresentationController = flagViewController.popoverPresentationController
        popoverPresentationController?.sourceView = sender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(ViewPostViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
       
        self.title = "View Post"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Pacifico-Regular", size: 20)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        loaderConfig.size = 150
        loaderConfig.spinnerColor = UIColor(red: 97.0/255, green: 184.0/255, blue: 223.0/255, alpha: 1.0)
        loaderConfig.foregroundColor = .whiteColor()
        loaderConfig.foregroundAlpha = 0.5
        
        SwiftLoader.setConfig(loaderConfig)
        SwiftLoader.show("Loading...", animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getPost()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.postTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    func createTextField() -> UITextField{
        let textView = UITextField(frame: CGRectMake(8.0, 5.0, (ScreenSize.SCREEN_WIDTH * 0.96), 34.0))
        textView.placeholder = "Reply"
        textView.backgroundColor = UIColor.whiteColor()
        textView.font = UIFont.systemFontOfSize(17)
        textView.borderStyle = UITextBorderStyle.RoundedRect
        textView.autocorrectionType = UITextAutocorrectionType.No
        textView.keyboardType = UIKeyboardType.Default
        textView.returnKeyType = UIReturnKeyType.Done
        textView.clearButtonMode = UITextFieldViewMode.WhileEditing;
        textView.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        textView.delegate = self
        return textView
    }
    
    private func getPost() {
        PostApiManager.sharedInstance.getPost(postId) {
            (result: JSON) in
            SwiftLoader.hide()
            self.post = result
            self.comments = result["Comments"].arrayValue
            self.postTable.reloadData()
            
        }
    }
    
    private func createComment(commentText: String!) {
        let payload = ["userid": "\(userId)", "postid": "\(postId)", "text": "\(commentText)"]
        CommentApiManager.sharedInstance.postComment(payload) {
            (result: AnyObject) in
            
//            self.getPost()
//            self.postTable.reloadData()
            
        }
    }
    
    @IBAction func upvote(sender: AnyObject) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let postInfo = self.post[sender.tag]
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SinglePostCell!
        let cellData = self.post[indexPath.row]
        let voteCount = (cellData["VoteCount"].intValue) + 1
        cell.voteCountLabel.text = "\(voteCount)"
        let payload = ["postid": "\(postInfo["PostId"])", "userid": userId, "votetype": "Up"]
        VoteApiManager.sharedInstance.vote(payload) {
            (result: String) in
            
        }

    }
    
    @IBAction func downvote(sender: AnyObject) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let postInfo = self.post[sender.tag]
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SinglePostCell!
        let cellData = self.post[indexPath.row]
        var voteCount = (cellData["VoteCount"].intValue)
        if voteCount == 0 {
            voteCount = -1
        }
        cell.voteCountLabel.text = "\(voteCount)"
        let payload = ["postid": "\(postInfo["PostId"])", "userid": userId, "votetype": "Down"]
        VoteApiManager.sharedInstance.vote(payload) {
            (result: String) in
            
        }
    }
    
    func preparePostCell(cell:SinglePostCell, indexPath:NSIndexPath) {
        let text = self.post["Text"].stringValue
        let voteCount = self.post["VoteCount"].intValue
        let url = NSURL(string: self.post["ContentURL"].stringValue)
        let data = NSData(contentsOfURL: url!)
        let postImage = UIImage(data: data!)
        
        cell.titleLabel.text = text
        cell.voteCountLabel.text = "\(voteCount)"
        cell.postImageView.layer.cornerRadius = 3.0
        cell.postImageView.clipsToBounds = true
        cell.postImageView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleWidth]
        cell.postImageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.postImageView.kf_setImageWithURL(url!,
            placeholderImage: UIImage(named: "placeholder"),
            optionsInfo: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                if image != nil {
                    print("Downloaded and set!")
                }
                if error != nil {
                    print("The image isn't there yet.")
                }
            }
        )
        cell.upvoteButton.tag = indexPath.section
        cell.downvoteButton.tag = indexPath.section 
        cell.upvoteButton.addTarget(self, action: "upvote:", forControlEvents: .TouchUpInside)
        cell.downvoteButton.addTarget(self, action: "downvote:", forControlEvents: .TouchUpInside)
    }
    
    func prepareCommentCell(cell:CommentCell, indexPath:NSIndexPath) {
        let cellData = self.comments[indexPath.row]
        let name = cellData["PostUsername"].stringValue
        let comment = cellData["Text"].stringValue
        let voteCount = cellData["VoteCount"].intValue
        
        
        // Adding an out going chat bubble
        let commentBubbleData = ChatBubbleData(text: comment, image: nil, date: NSDate(), type: .Opponent)
        let commentBubble = ChatBubble(data: commentBubbleData, startY: 5)
        cell.commentBubbleView.addSubview(commentBubble)
        cell.commentUserLabel.text = name
        cell.voteCountLabel.text = "\(voteCount)"
        

//        let text = self.post["Text"].stringValue
//        let voteCount = self.post["VoteCount"].intValue
//        let url = NSURL(string: self.post["ContentURL"].stringValue)
//        let data = NSData(contentsOfURL: url!)
//        let postImage = UIImage(data: data!)
//        
//        cell.titleLabel.text = text
//        cell.voteCountLabel.text = "\(voteCount)"
//        //        cell.postImage.contentMode = .ScaleAspectFit
//        cell.postImageView.image = postImage
//        cell.upvoteButton.tag = indexPath.section
//        cell.downvoteButton.tag = indexPath.section
//        cell.upvoteButton.addTarget(self, action: "upvote:", forControlEvents: .TouchUpInside)
//        cell.downvoteButton.addTarget(self, action: "downvote:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Segues
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SinglePostCell", forIndexPath: indexPath) as! SinglePostCell
            preparePostCell(cell, indexPath: indexPath)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
            prepareCommentCell(cell, indexPath: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReplyCell", forIndexPath: indexPath) as! ReplyCell
            postTable.tableFooterView  = cell
            cell.replyTextField.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0 {
            rowCount = self.post != nil ? 1 : 0
        }
        if section == 1 {
            rowCount = self.comments != nil ? self.comments.count : 0
        }
        if section == 2 {
            rowCount = 1
        }
        return rowCount
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let sizeRect = UIScreen.mainScreen().bounds
            return ((sizeRect.height) * 0.75)
        } else if indexPath.section == 1 {
            return 100
        }
        else {
            return 44
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        createComment(textField.text)
        var newComment: [String:String]
        newComment = ["PostUsername": "Generating...", "Text": textField.text!, "VoteCount": "0"]
        textField.text = ""
        self.comments.append(JSON(newComment))
        self.postTable.reloadData()
        return true
    }
    
}
