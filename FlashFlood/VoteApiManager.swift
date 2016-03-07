//
//  VoteApiManager.swift
//  FlashFlood
//
//  Created by Braden Casperson on 3/5/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VoteApiManager : NSObject {
    static let sharedInstance = VoteApiManager()
    
    func vote(payload: [String:String], onCompletion: (result: String) -> Void){
        
        Alamofire.request(.POST, "http://api.flashflood.me/vote/post", parameters: payload)
            .responseString { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        if value == "Vote Added" {
                            onCompletion(result: ("Success"))
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
//    private func createPost(parameters: [String : AnyObject]!) {
//        
//        Alamofire.request(.POST, "https://api.flashflood.me/posts/recent", parameters: parameters)
//            .responseJSON { response in
//                print(response.request)
//                print(response.response)
//                print(response.data)
//                print(response.result)
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
//        
//    }
}
