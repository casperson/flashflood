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

let albumName = "Flashflood"

class RecentActivityViewController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var posts = [[String:AnyObject]]()
    let calendar = NSCalendar.currentCalendar()
    var pickedImage: UIImage?
    var newPostPath: NSURL?
    var newMedia: Bool?
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var albumFound : Bool = false
    var tabBarIndex: Int?
    let userId = String(NSUserDefaults.standardUserDefaults().integerForKey("userId"))

    
    @IBOutlet weak var viewPost: UIButton!
    @IBOutlet var postsTable: UITableView!
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.postsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let first_Obj: AnyObject = collection.firstObject {
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        } else {
            var albumPlaceholder:PHObjectPlaceholder!
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
                },
                completionHandler: {(success:Bool, error:NSError?)in
                    if(success){
                        print("Successfully created folder")
                        self.albumFound = true
                        let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil)
                        self.assetCollection = collection.firstObject as! PHAssetCollection
                    }else{
                        print("Error creating folder")
                        self.albumFound = false
                    }
            })
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
        getRecentPosts()
    }
    
    override func viewDidAppear(animated: Bool) {
        tabBarIndex = self.tabBarController?.selectedIndex
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.postsTable.reloadData()
        refreshControl.endRefreshing()
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
            self.dismissViewControllerAnimated(true, completion: nil);
            self.performSegueWithIdentifier("Show New Post", sender: self)

            
//            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//            dispatch_async(dispatch_get_global_queue(priority, 0), {
//                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
//                    let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
//                    if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset) {
//                        albumChangeRequest.addAssets([assetPlaceholder!])
//                    }
//                    }, completionHandler: {(success, error) in
//                        dispatch_async(dispatch_get_main_queue(), {
//                            NSLog("Adding Image to Library -> %@", (success ? "Success":"Error!"))
//                            if success {
                                self.dismissViewControllerAnimated(true, completion: nil);
                                self.performSegueWithIdentifier("Show New Post", sender: self)
//                            }
////                            picker.dismissViewControllerAnimated(true, completion: nil)
//                        })
//                })
//                
//            })
        }
        //        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
//        if mediaType == kUTTypeImage as String {
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//            UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
//            } else if mediaType == kUTTypeMovie as String) {
//                // Code to support video here
//            }
//            
//            let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
//            let imageName         = imageUrl.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
//            let newPostDirectory  = NSURL(fileURLWithPath: documentDirectory)
//            let localPath         = newPostDirectory.URLByAppendingPathComponent(imageName!)
//            let path              = localPath.relativePath
//            
//            if mediaType == kUTTypeImage as String {
//                pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//                let data    = pickedImage!.lowQualityJPEGNSData
//                data.writeToFile(localPath.absoluteString, atomically: true)
//                newPostPath = NSURL(fileURLWithPath: path!)
//                performSegueWithIdentifier("Show New Post", sender: self)
//            }
        
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
    
    private func getRecentPosts() {
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
                        (($0 as! Dictionary<String, AnyObject>)["CommentCount"] as? Int) < (($1 as! Dictionary<String, AnyObject>)["CommentCount"] as? Int)
                    }
                }
//            }
            
            self.postsTable.reloadData()
            self.postsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
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
    
//    func updateVote(indexPath:NSIndexPath) {
//        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
//        let cellData = self.posts[indexPath.row]
//        let voteCount = cellData["VoteCount"] as? Int
//        cell.voteCountLabel.text = "\(voteCount! + 1)"
//        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
//    }
    
    func fillCellData(cell:PostCell, indexPath:NSIndexPath) {
        let cellData = self.posts[indexPath.row]
        let commentsCount = cellData["CommentCount"] as? Int
        let text = cellData["Text"] as? String
        let voteCount = cellData["VoteCount"] as? Int
        let url = NSURL(string: (cellData["ThumbnailURL"] as? String)!)
        let data = NSData(contentsOfURL: url!)
//        if UIImage(data: data!) != nil {
            let postImage = UIImage(data: data!)
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
        cell.postImage.image = postImage
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
                let convertedImageData: NSData = UIImagePNGRepresentation(self.pickedImage!)!
                destVC.imageData = convertedImageData
                destVC.uploadImage = self.pickedImage

                let asset: PHAsset = self.photosAsset.lastObject as! PHAsset
                let localIdentifier = String(asset.valueForKey("localIdentifier")!)
                let index1 = localIdentifier.startIndex.advancedBy(36)
                let substring1 = localIdentifier.substringToIndex(index1)
                let path = "assets-library://asset/asset.JPG?id=\(substring1)&ext=JPG"
                
                PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil, resultHandler: {(result, info) in
                    if let image = result {
//                        destVC.uploadImage = self.pickedImage
                    }
                })
                
                PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil, resultHandler: { (imageData, dataUTI, UIImageOrientation, info) -> Void in
//                        let convertedImageData: NSData = UIImagePNGRepresentation(self.pickedImage!)!
//                        destVC.imageData = convertedImageData
                })
                destVC.newPostPath = NSURL(string: path)
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