//
//  Post.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/13/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Post {
    
    var title: String?
    var userId: String
    var thumbnailUrl: NSURL
    var imageUrl: NSURL
    var voteCount: Int
    var dateTimePosted: Int
    var latitude: Int
    var longitude: Int
    var offensiveFlagCount: Int
    var spamFlagCount: Int
    var advertisingFlagCount: Int
    var targetingFlagCount: Int
    
    init(title: String, userId: String, thumbnailUrl: NSURL, imageUrl: NSURL, voteCount: Int, dateTimePosted: Int, latitude: Int, longitude: Int, offensiveFlagCount: Int, spamFlagCount: Int, advertisingFlagCount: Int, targetingFlagCount: Int) {
        
        self.title = "title"
        self.userId = userId
        self.thumbnailUrl = thumbnailUrl
        self.imageUrl = imageUrl
        self.voteCount = voteCount
        self.dateTimePosted = dateTimePosted
        self.latitude = latitude
        self.longitude = longitude
        self.offensiveFlagCount = offensiveFlagCount
        self.spamFlagCount = spamFlagCount
        self.advertisingFlagCount = advertisingFlagCount
        self.targetingFlagCount = targetingFlagCount

    }
        
    // MARK: - Deserialization
    
//    init?(json: JSON) {
//        guard let userId: String = "UserId" <~~ json
//            else { return nil }
//
//        guard let thumbnailUrl: NSURL = "ThumbnailURL" <~~ json
//            else { return nil }
//
//        guard let imageUrl: NSURL = "ImageURL" <~~ json
//            else { return nil }
//
//        guard let voteCount: Int = "VoteCount" <~~ json
//            else { return nil }
//
//        guard let dateTimePosted: Int = "DateTimePosted" <~~ json
//            else { return nil }
//
//        guard let latitude: Int = "Latitude" <~~ json
//            else { return nil }
//
//        guard let longitude: Int = "Longitude" <~~ json
//            else { return nil }
//
//        guard let offensiveFlagCount: Int = "OffensiveFlagCount" <~~ json
//            else { return nil }
//
//        guard let spamFlagCount: Int = "SpamFlagCount" <~~ json
//            else { return nil }
//        
//        guard let advertisingFlagCount: Int = "AdvertisingFlagCount" <~~ json
//            else { return nil }
//        
//        guard let targetingFlagCount: Int = "TargetingFlagCount" <~~ json
//            else { return nil }

        //    }
}
