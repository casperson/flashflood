//
//  UserActivityViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 1/15/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserActivityViewController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var postsTable: UITableView!
    var posts = [[String:AnyObject]]()
    let calendar = NSCalendar.currentCalendar()
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getRecentPosts()
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.Camera) {
//                
//                let imagePicker = UIImagePickerController()
//                
//                imagePicker.delegate = self
//                imagePicker.sourceType =
//                    UIImagePickerControllerSourceType.Camera
//                
//                self.presentViewController(imagePicker, animated: true, 
//                    completion: nil)
//        }
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
//                imagePicker.mediaTypes = [kUTTypeImage as NSString]
//                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
//                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        performSegueWithIdentifier("Show New Post", sender: self)
//            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
//            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
        })
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "New Post" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destVC = segue.destinationViewController as? NewPostViewController {
//                    destVC.image = pickedImage
                }
            }
        }
    }
    
    private func getRecentPosts() {
        
        Alamofire.request(.POST, "http://api.flashflood.me/posts", parameters: ["latitude": "40.2454721", "longitude": "111.65965699999998"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.posts = (json["Items"].arrayObject as? [[String:AnyObject]])!
                        self.postsTable.reloadData()
                        //                        print("JSON: \(json)")
                    }
                case .Failure(let error):
                    print(error)
                }
                
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return postCellAtIndexPath(indexPath)
    }
    
    func postCellAtIndexPath(indexPath:NSIndexPath) -> PostCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        fillCellData(cell, indexPath: indexPath)
        return cell
    }
    
    func fillCellData(cell:PostCell, indexPath:NSIndexPath) {
        let cellData = self.posts[indexPath.row]
        let image : UIImage = UIImage(named: "cat")!
        let postedDateDouble = cellData["DateTimePosted"] as? Int
        let postDate = NSDate(timeIntervalSince1970: Double(postedDateDouble!))
        let currentDate = NSDate()
        let datecomponents = calendar.components(NSCalendarUnit.Hour, fromDate: postDate, toDate: currentDate, options: [])
        //        let timeElapsed = datecomponents.hour
        
        cell.titleLabel.text = cellData["Text"] as? String
        //        cell.timeElapsedLabel.text = String(timeElapsed)
        cell.timeElapsedLabel.text = "12h"
        //cell.voteCountLabel.text = cellData["Text"] as? String
        cell.voteCountLabel.text = "13"
        //cell.repliesCountLabel.text = cellData["Text"] as? String
        cell.repliesCountLabel.text = "12\nReplies"
        cell.postImage.image = image
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250 //the height of your table view cell, the default value is 44
    }

    
}
