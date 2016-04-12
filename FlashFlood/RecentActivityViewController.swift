//
//  RecentActivityViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 1/15/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MobileCoreServices
import Photos
import Kingfisher

let albumName = "Flashflood"

class RecentActivityViewController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate {
    
    // MARK: - Properties
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var posts = [[String:AnyObject]]()
    let calendar = NSCalendar.currentCalendar()
    var pickedImage: UIImage?
    var newPostPath: NSURL?
    var newMedia: Bool?
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var albumFound : Bool = false
    var tabBarIndex: Int?
    let userId = String(NSUserDefaults.standardUserDefaults().stringForKey("token"))
    var postTimer = NSTimer()
    var userTimer = NSTimer()
    var locManager = CLLocationManager()

    
    @IBOutlet weak var viewPost: UIButton!
    @IBOutlet var postsTable: UITableView!
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.postsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
        let notFirstLaunch = userDefaults.boolForKey("FirstLaunch")
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        if notFirstLaunch  {
            self.postTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RecentActivityViewController.getRecentPosts), userInfo: nil, repeats: true)
            print("Not First Launch")
        } else {
            self.userTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RecentActivityViewController.createUser), userInfo: nil, repeats: true)
            
            userDefaults.setBool(true, forKey: "FirstLaunch")
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        tabBarIndex = self.tabBarController?.selectedIndex
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getRecentPosts()
        refreshControl.endRefreshing()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated Locations")
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
                if (availableTypes as NSArray).containsObject(kUTTypeMovie) {
//                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                    // proceed to present the picker
                }
            }
        }
        
//        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//            newMedia = false
////        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            //Implement if allowing user to edit the selected image
            //let editedImage = info.objectForKey("UIImagePickerControllerEditedImage") as UIImage
            
            pickedImage = image
            self.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("Show New Post", sender: self)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func downvote(sender: AnyObject) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let postInfo = self.posts[sender.tag]
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PostCell!
        let cellData = self.posts[indexPath.row]
        var voteCount = (cellData["VoteCount"] as? Int)!
        if voteCount == 0 {
            voteCount = -1
        }
        cell.voteCountLabel.text = "\(voteCount)"
        
        let payload = ["postid": "\(postInfo["PostId"]!)", "userid": userId, "votetype": "Down"]
        VoteApiManager.sharedInstance.vote(payload) {
            (result: String) in
        
        }
    }
    @IBAction func upvote(sender: AnyObject) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let postInfo = self.posts[sender.tag]
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PostCell!
        let cellData = self.posts[indexPath.row]
        let voteCount = (cellData["VoteCount"] as? Int)! + 1
        cell.voteCountLabel.text = "\(voteCount)"
        
        let payload = ["postid": "\(postInfo["PostId"]!)", "userid": userId, "votetype": "Up"]
        VoteApiManager.sharedInstance.vote(payload) {
            (result: String) in
        
        }
    }
    
    @objc private func createUser() {
        print(locManager.location?.coordinate.latitude)
        if locManager.location != nil {
            userDefaults.setDouble((locManager.location?.coordinate.latitude)!, forKey: "latitude")
            userDefaults.setDouble((locManager.location?.coordinate.longitude)!, forKey: "longitude")
            UserApiManager.sharedInstance.createUser() {
                (result: JSON) in
                self.userTimer.invalidate()
                self.getRecentPosts()
                print(result)
            }
        }
    }
    
    @objc private func getRecentPosts() {
        print(locManager.location?.coordinate.latitude)
        if locManager.location != nil {
            userDefaults.setDouble((locManager.location?.coordinate.latitude)!, forKey: "latitude")
            userDefaults.setDouble((locManager.location?.coordinate.longitude)!, forKey: "longitude")
            var urls = [NSURL]()
            PostApiManager.sharedInstance.getPosts() {
                (result: [[String:AnyObject]]) in
                self.posts = result
    //            var application: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //            var tabbarController = application.tabBarController as UITabBarController
    //            if let tabBarController = self.window!.rootViewController as? UITabBarController {
                    if self.tabBarIndex == 1 {
                        self.posts.sortInPlace{
                            (($0 as! Dictionary<String, AnyObject>)["DateTimePosted"] as? Int) > (($1 as! Dictionary<String, AnyObject>)["DateTimePosted"] as? Int)
                        }
                    }
                    else if self.tabBarIndex == 0 {
                        self.posts.sortInPlace{
                            (($0 as! Dictionary<String, AnyObject>)["VoteCount"] as? Int) > (($1 as! Dictionary<String, AnyObject>)["VoteCount"] as? Int)
                        }
                    }
    //            }
                
                for post in self.posts {
                    let tURL = NSURL(string: (post["ThumbnailURL"] as? String)!)
                    let cURL = NSURL(string: (post["ContentURL"] as? String)!)
                    urls.append(tURL!)
                    urls.append(cURL!)
                }
                let prefetcher = ImagePrefetcher(urls: urls, optionsInfo: nil, progressBlock: nil, completionHandler: {
                    (skippedResources, failedResources, completedResources) -> () in
                    print(failedResources)
                })
                prefetcher.start()
                self.postsTable.reloadData()
                self.postsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.postTimer.invalidate()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return postCellAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Show View Post", sender: self)
    }
    
    func postCellAtIndexPath(indexPath:NSIndexPath) -> PostCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        fillCellData(cell, indexPath: indexPath)
        return cell
    }
    
    func fillCellData(cell:PostCell, indexPath:NSIndexPath) {
        let cellData = self.posts[indexPath.row]
        let commentsCount = cellData["CommentCount"] as? Int
        let text = cellData["Text"] as? String
        let voteCount = cellData["VoteCount"] as? Int
        let url = NSURL(string: (cellData["ThumbnailURL"] as? String)!)
//        let data = NSData(contentsOfURL: url!)
//        if UIImage(data: data!) != nil {
//            let postImage = UIImage(data: data!)
//        }
        
        let postedDate = (cellData["DateTimePosted"] as? Int)!/1000
        let postDate = NSDate(timeIntervalSince1970: NSTimeInterval(postedDate))
        let currentDate = NSDate()
        let datecomponents = calendar.components(NSCalendarUnit.Hour, fromDate: postDate, toDate: currentDate, options: [])
        let timeElapsed = String(datecomponents.hour)
        
        cell.titleLabel.text = text
        cell.timeElapsedLabel.text = timeElapsed + "h"
        cell.voteCountLabel.text = "\(voteCount!)"
        if commentsCount == 1 {
            cell.repliesCountLabel.text = "\(commentsCount!) \nReply"
        } else {
            cell.repliesCountLabel.text = "\(commentsCount!) \nReplies"
        }
        cell.postImage.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleWidth]
        cell.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.postImage.layer.cornerRadius = 3.0
        cell.postImage.clipsToBounds = true
        cell.postImage.kf_setImageWithURL(url!,
            placeholderImage: UIImage(named: "placeholder"),
            optionsInfo: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                if image != nil {
//                    print("Downloaded and set!")
                }
                if error != nil {
                    print("The image isn't there yet.")
                }
            }
        )
//        cell.postImage.image = postImage
        cell.upvoteButton.tag = indexPath.row
        cell.downvoteButton.tag = indexPath.row
        cell.upvoteButton.addTarget(self, action: "upvote:", forControlEvents: .TouchUpInside)
        cell.downvoteButton.addTarget(self, action: "downvote:", forControlEvents: .TouchUpInside)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sizeRect = UIScreen.mainScreen().bounds
        return (sizeRect.height/3) //the height of your table view cell, the default value is 44
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show New Post" {
            if let destVC = segue.destinationViewController as? NewPostViewController {
//                let convertedImageData: NSData = UIImagePNGRepresentation(self.pickedImage!)!
//                destVC.imageData = convertedImageData
                destVC.uploadImage = self.pickedImage

            }
        }
        
        if segue.identifier == "Show View Post" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destVC = segue.destinationViewController as? ViewPostViewController {
                    let cellData = posts[indexPath.row]
//                    let url = NSURL(string: (cellData["ContentURL"] as? String)!)
//                    let data = NSData(contentsOfURL: url!)
//                    destVC.image = UIImage(data: data!)
//                    destVC.title = cellData["Text"] as? String
                    destVC.postId = (cellData["PostId"] as? String)!
                }
            }
        }
    }
    
}

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}