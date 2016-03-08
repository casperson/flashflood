//
//  CommentApiManager.swift
//  FlashFlood
//
//  Created by Braden Casperson on 3/8/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentApiManager : NSObject {
    static let sharedInstance = CommentApiManager()
    
    func postComment(payload: [String:String], onCompletion: (result: AnyObject) -> Void){
        
        Alamofire.request(.POST, "http://api.flashflood.me/comment", parameters: payload)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        onCompletion(result: json["Item"].object as! AnyObject)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}

