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

class PostApiManager : NSObject {
    static let sharedInstance = PostApiManager()
    
    func getPosts(latitude: Int?, longitude: Int?, onCompletion: (result: [[String:AnyObject]]) -> Void){
        
        Alamofire.request(.POST, "http://api.flashflood.me/posts", parameters: ["latitude": "40.2454721", "longitude": "111.65965699999998"])
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

    func getPost(postId: Int?, onCompletion: (result: [String:AnyObject]) -> Void){
        let url = "http://api.flashflood.me/post?postid=\(postId!)"
//        var arrayObj: [String:AnyObject]
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
//                        arrayObj.add(json)
                        print(json)
//                        onCompletion(result: (json[0]. as? [String:AnyObject])!)
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