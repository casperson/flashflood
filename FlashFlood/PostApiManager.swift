//
//  PostApiManager.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/6/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class PostApiManager : NSObject, CLLocationManagerDelegate {
    static let sharedInstance = PostApiManager()
    var locManager = CLLocationManager()
    var timer = NSTimer()

    func initLocation() {
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated Locations")
    }
    
    func getPosts(onCompletion: (result: [[String:AnyObject]]) -> Void){
        let latitude = NSUserDefaults.standardUserDefaults().stringForKey("latitude")
        let longitude = NSUserDefaults.standardUserDefaults().stringForKey("latitude")
        let accessToken = NSUserDefaults.standardUserDefaults().stringForKey("token")
        let headers = [
            "x-access-token": accessToken!
        ]
        
        Alamofire.request(.POST, "http://api.flashflood.me/posts", parameters: ["latitude": latitude!, "longitude": longitude!, "distance": "50000000"], headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        onCompletion(result: (json["Items"].arrayObject as? [[String:AnyObject]])!)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
//    func getRecentPosts() -> [[String:AnyObject]]{
//        getPosts(nil, longitude: nil) {
//            (result: [[String:AnyObject]]) in
//            
//        }
//        return result
//    }

    func getPost(postId: String?, onCompletion: (result: JSON) -> Void){
        let url = "http://api.flashflood.me/post?postid=\(postId!)"
        
        let accessToken = NSUserDefaults.standardUserDefaults().stringForKey("token")
        let headers = [
            "x-access-token": accessToken!
        ]
        
        Alamofire.request(.GET, url, headers: headers, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
//                        arrayObj.add(json)
//                        print(json)
                        onCompletion(result: json)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    private func getUserPosts() {
        
        Alamofire.request(.GET, "https://api.flashflood.me/posts/recent", parameters: nil)
            .responseJSON { response in
                print(response.request)
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
    }

    private func createPost(parameters: [String : AnyObject]!) {
        
        Alamofire.request(.POST, "https://api.flashflood.me/posts/recent", parameters: parameters)
            .responseJSON { response in
                print(response.request)
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
    }
}