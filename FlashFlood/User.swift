//
//  User.swift
//  FlashFlood
//
//  Created by Braden Casperson on 2/13/16.
//  Copyright © 2016 Braden Casperson. All rights reserved.
//

import Foundation
import Gloss

struct User: Decodable {
    let userId: String
    let reputationCount: Int
    let flagCount: Int
    let latitude: Int
    let longitude: Int
    let deviceId: String
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let userId: String = "UserId" <~~ json
            else { return nil }
        
        guard let reputationCount: Int = "ReputationCount" <~~ json
            else { return nil }
        
        guard let flagCount: Int = "FlagCount" <~~ json
            else { return nil }
        
        guard let latitude: Int = "Latitude" <~~ json
            else { return nil }
        
        guard let longitude: Int = "Longitude" <~~ json
            else { return nil }
        
        guard let deviceId: String = "DeviceID" <~~ json
            else { return nil }
        
        self.userId = userId
        self.deviceId = deviceId
        self.reputationCount = reputationCount
        self.flagCount = flagCount
        self.latitude = latitude
        self.longitude = longitude
    }
}
