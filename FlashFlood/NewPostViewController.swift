//
//  NewPostViewController.swift
//  FlashFlood
//
//  Created by Braden Casperson on 1/15/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import Photos

class NewPostViewController : UIViewController {
    
    // MARK: - Properties
    
    var locManager = CLLocationManager()
    var userId: String!
    var newPostPath: NSURL!
    var uploadImage: UIImage!
    var imageData: NSData!
    let postURL = "http://api.flashflood.me/post"
    var photosAsset: PHFetchResult!
    var index: Int = 0
    
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        showCameraPhoto()
    }
    
    @IBAction func savePost(sender: AnyObject) {
        Alamofire.upload(
            .POST,
            postURL,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.uploadImage, 1.0)!, name: "fileUpload", fileName: "iosFile.jpg", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: "9".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"userid")
                multipartFormData.appendBodyPart(data: self.postTitle.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"text")
                multipartFormData.appendBodyPart(data:"40".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"latitude")
                multipartFormData.appendBodyPart(data:"-111".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"longitude")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        self.performSegueWithIdentifier("unwindToMenu", sender: self)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func showCameraPhoto() {
        let aspectRatio = uploadImage.size.width / uploadImage.size.height
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: aspectRatio, constant: 0.0))
        userId = String(NSUserDefaults.standardUserDefaults().integerForKey("userId"))
//        imageView.contentMode = .ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleWidth]
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.layer.cornerRadius = 3.0
        imageView.clipsToBounds = true
        imageView.image = uploadImage
//        let screenSize: CGSize = UIScreen.mainScreen().bounds.size
//        let targetSize = CGSizeMake(screenSize.width, screenSize.height)
//        
//        let imageManager = PHImageManager.defaultManager()
//        if let asset = self.photosAsset[self.index] as? PHAsset{
//            imageManager.requestImageForAsset(asset, targetSize: targetSize, contentMode: .AspectFit, options: nil, resultHandler: {
//                (result, info)->Void in
//                self.imageView.image = result
//            })
//        }
    }

    // MARK: - Segues
}
    

